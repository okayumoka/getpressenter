require 'nokogiri'
require 'open-uri'
require 'fileutils'

puts 'Press Enterの本文を取得します。'

$url_base = 'http://el.jibun.atmarkit.co.jp/pressenter/'
$index_page_max = 99

# インデックスページを開き、コンテンツ（小説）ページへのリンク一覧を取得する。
def getContentUrlList(index_num)
  if index_num == 1
    html_file_name = "index.html"
  else
    html_file_name = "index_#{index_num}.html"
  end
  url = $url_base + html_file_name

  charset = nil
  begin
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
  rescue => e
    # urlがひらけなかった時
    puts "Cannot open url: #{url}"
    raise
  end

  # puts html

  link_url_list = []

  # doc = Nokogiri::HTML.parse(html, nil, charset)
  doc = Nokogiri::HTML.parse(html, url)
  doc.xpath("//div[@class='colBox colBoxArticleIndex']").each do |content_node|
    content_node.xpath("//div[@class='colBoxIndex']").each do |div_node|
      div_node.xpath("a").each do |a_node|
        # puts a_node[:href]
        link_url_list << a_node[:href]
      end
    end
  end

  return link_url_list
end

# 本文を取得
def getNovel(url)
  charset = nil
  html = open(url) do |f|
    charset = f.charset
    f.read
  end

  # doc = Nokogiri::HTML.parse(html, nil, charset)
  doc = Nokogiri::HTML.parse(html, url)
  title = doc.css("#cmsTitle").first.at(:h1).text
  text = doc.css("#cmsBody").first.css(".inner").text

  return {
    url: url,
    title: title, 
    text: text
  }
end

# ファイル保存
def saveFile(filename, text)
  path = "output/#{filename}.txt"
  File.open(path, 'w') do |f|
    f.puts text
    puts "write #{path}"
  end
end


# 本編リンクをすべて取得
content_url_list = []
1.step do |i|
  break if i >= $index_page_max
  begin
    content_url_list += getContentUrlList(i)
  rescue
    break
  end
end
# puts content_url_list

# 本文取得と保存
FileUtils.mkdir_p('./output')
novel_list = []
content_url_list.each do |url|
  novel = getNovel(url)
  novel_list << novel
  saveFile novel[:title], novel[:text]
end

# インデックスを保存
index_file_text = ""
novel_list.each do |novel|
  index_file_text += "#{novel[:title]}\t#{novel[:url]}\n"
end
puts index_file_text
saveFile "index", index_file_text



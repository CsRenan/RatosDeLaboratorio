require "erb"

def primeiro_conteudo_para(secao)
  todos_conteudo_secao = Dir.glob("pages/#{secao}/*.html")
  todos_conteudo_secao.sort!{|x,y| File.ctime(x) <=> File.ctime(y)}
  todos_conteudo_secao.reverse!
  primeiro_conteudo_secao = get_heading_for(todos_conteudo_secao.first)
end

def varios_conteudos_para(secao)
  todos_conteudo_secao = Dir.glob("pages/#{secao}/*.html")
  todos_conteudo_secao.sort!{|x,y| File.ctime(x) <=> File.ctime(y)}
  todos_conteudo_secao.reverse!
  todos_conteudo_secao.map do |conteudo_secao|
    get_heading_for(conteudo_secao)
  end
end

def get_template_list
  template_secao = Dir.glob("template/*.html")
end

def get_secoes_mapping
  secoes = Hash.new
  get_template_list.each do |template_path|
   secoes[template_path[/\/[^_]*/][1..-1]]=template_path
  end
  return secoes
end


def get_heading_for(file)
  File.open(file).read.slice(/<!-- HEADING -->.*<!-- END HEADING -->/m)
end

def content
  @content.shift || String.new
end

def generate_index
  template = ERB.new(File.read(get_secoes_mapping['index']))
  @content = [primeiro_conteudo_para('index')]
  result = template.result(binding)
  File.open('index.html','w'){|f| f.write(result)}
end

def generate_multiple_entries_secao(secao)
  puts "Generating #{secao}"
  template = ERB.new(File.read(get_secoes_mapping[secao]))
  conteudos = varios_conteudos_para(secao)
  conteudos.each_slice(9).each_with_index do |page_content,index|
    @content = page_content
    result = template.result(binding)
    filename = "#{secao}#{index if index!=0}.html"
    puts "Generating #{filename}"
    File.open(filename,'w'){|f| f.write(result)}
  end
end

puts "Generating index"
generate_index
['aprenda','podcast','homebrew'].each do |secao|
generate_multiple_entries_secao(secao)
end

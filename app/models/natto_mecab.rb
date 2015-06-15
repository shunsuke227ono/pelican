class NattoMecab
  # 今回使いたい用法に限定。名詞/動詞
  def initialize
    @nm ||= Natto::MeCab.new('-F%m,\s%f[0]')
  end
  def nouns_and_verbs(content)
    @nm.enum_parse(content).map{ |x| x.surface if x.feature[-2..-1]=="名詞" || x.feature[-2..-1]=="動詞" }.compact
  end
  def nouns(content)
    @nm.enum_parse(content).map{ |x| x.surface if x.feature[-2..-1]=="名詞" }.compact
  end
end

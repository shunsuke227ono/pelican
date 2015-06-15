class TfIdfCalculation
  def initialize(data, similar_article_base_index)
    @data = data
    @similar_article_base_index = similar_article_base_index
    # similar_article_base_index を 0にすれば全件から推薦記事持ってこれる。
    # ここを調整することで推薦記事候補の幅決められる
  end
  def tf
    # 文章内でのそれぞれの単語の頻度 Hashで返す
    @tf ||= calculate_term_frequencies
  end
  def idf
    @idf ||= calculate_inverse_document_frequencies
  end
  def tf_idf
    # hashを返す
    # それぞれのコンテンツ内に存在する単語に関してのみ
    tf_idf = tf.map(&:clone)
    tf.each_with_index do |content, index|
      content.each_pair do |term, tf_score|
        tf_idf[index][term] = tf_score * idf[term]
      end
    end
  end
  def tf_idf_with_all_characteristics
    # arrayを返す
    # 特徴ベクトルの要素に対するすべてのベクトルの特徴量
    # つまり長さは全ベクトル等しくなる
    tf_idf_with_all_characteristics = []
    tf_idf.each do |content|
      tf_idf_for_one_content = []
      unique_terms.each do |term|
        tf_idf_for_one_content << content[term] || 0
      end
      tf_idf_with_all_characteristics << tf_idf_for_one_content
    end
    tf_idf_with_all_characteristics
  end
  def cos_distance_matrix
    # コサイン距離: 1に近いほどベクトル同士の意味が近い
    # n: サンプル数 とした時
    # n*n行行列を返す。array[i][j]はiとjの距離
    # 計算オーダーはn*n。実際はn*n/2。
    return @cos_distance_matrix if @cos_distance_matrix.present?
    @cos_distance_matrix = []
    content_count.times{ @cos_distance_matrix << Array.new(content_count,0) }
    tf_idf_with_all_characteristics[0...@similar_article_base_index].each_with_index do |origin_vector, index|
      tf_idf_with_all_characteristics[@similar_article_base_index..-1].each_with_index do |goal_vector, additional_index|
        goal_index = @similar_article_base_index + additional_index
        cos_distance = VectorCalculation.cos_of(origin_vector, goal_vector)
        @cos_distance_matrix[index][goal_index] = cos_distance
        @cos_distance_matrix[goal_index][index] = cos_distance
      end
    end
    @cos_distance_matrix
  end
  def three_closest_cos_distance_indexes_from(origin_index)
    # @data[origin_index]から最も近い三つの@data[??]のindexを返す
    distance_row = cos_distance_matrix[origin_index]
    distance_row.map.with_index.sort.map(&:last)[-3..-1].reverse
  end

  private
  def content_count
    @data.size
  end
  def terms
    @terms ||= @data.map(&:uniq).flatten
  end
  def unique_terms
    @unique_terms ||= @data.flatten.uniq
  end
  def calculate_inverse_document_frequencies
    results = Hash.new { |h, k| h[k] = 0 }
    terms.each do |term|
      results[term] += 1
    end
    log_total_contents = Math.log10(content_count)
    results.each_pair do |term, count|
      results[term] = log_total_contents - Math.log10(count) + 1
    end
    results.default = nil
    results
  end
  def calculate_term_frequencies
    results = []
    @data.each do |content|
      content_size = content.size
      result = Hash.new { |h, k| h[k] = 0 }
      content.each do |term|
        result[term] += 1
      end
      result.each_key do |term|
        result[term] /= content_size.to_f
      end
      results << result
    end
    results
  end
end

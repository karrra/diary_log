module QueryWords
  def quick_search(content)
    data = json_request(content)
    <<-str
    Result:
    #{data.first['shortdef'].first}
    str
  end

  def full_search(content)
    data = json_request(content)
    result = "Result: "
    data.each do |meta|
      result += <<-str

    #{meta.fetch('fl')}
    #{meta['ins']&.map{|i| i.values}&.flatten&.join("\n") || '' }
    #{get_sense(meta['def'].first['sseq'])}

            str
    end
    result
  end

  def get_sense(data)
    data.map do |arr|
      arr.map do |sense|
        next unless sense[0] == 'sense'
        get_detail(sense[1]['dt']) || ''
      end
    end.join("\n")
  end

  def get_detail(data)
    data.map do |i|
      case i[0]
      when 'text'
        "def: #{i[1]}"
      when 'vis'
        "e.g: " + i[1].map{|t| t.values}.join("\n")
      # when 'uns'
      #   i[1].map
      else
        ''
      end
    end.join("\n")
  end

  def json_request(content)
    begin
      url = "https://dictionaryapi.com"
      conn = Faraday.new(url)
      res = conn.get do |req|
              req.url "/api/v3/references/learners/json/#{content.sub(/Tr /, '')}", key: '0ff1a193-4785-435e-a768-58ca9f582fe9'
            end
      if res.status == 200
        JSON.parse(res.body)
      else
        Rails.logger.error "=======error: #{res.body}"
      end
    rescue => e
      Rails.logger.error "======query words error: #{e}"
      nil
    end
  end
end

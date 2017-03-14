module AssemblyHelper
  def assembly_member(id)
    cachable_raw_data.detect { |member| member["id"] == id }
  end

  def assembly_members
    raw_data = cachable_raw_data
    raw_data.sort_by! do |member|
      weight = 1
      weight = 0 if (member["origNm"].try(:start_with?, '서울'))
      weight = 2 if (member["origNm"].try(:start_with?, '비례'))
      [weight, member["origNm"]]
    end
    raw_data.map { |member|
      [ "[#{member['origNm']}] #{member['empNm']} #{member['polyNm']}", "#{member['id']}"]
    }
  end

  def refresh_assembly_members
    Rails.cache.delete("assembly_areas")
    AssemblyHelper.prepare_assembly_members
  end

  def self.prepare_assembly_members
    Rails.cache.fetch("assembly_areas", expires_in: 10.days) do
      AssemblyHelper.load_data
    end
  end

  def self.load_data
    return [] if ENV['DATA_GO_KR_API_KEY'].blank?
    response_members = RestClient.get "http://apis.data.go.kr/9710000/NationalAssemblyInfoService/getMemberCurrStateList?numOfRows=400&serviceKey=#{ENV['DATA_GO_KR_API_KEY']}"
    result_members = Hash.from_xml(response_members.body)["response"]["body"]["items"]["item"]
    result_detail_members = result_members.map do |result_member|
      response_detail_member = RestClient.get "http://apis.data.go.kr/9710000/NationalAssemblyInfoService/getMemberDetailInfoList?num=#{result_member['num']}&dept_cd=#{result_member['deptCd']}&serviceKey=#{ENV['DATA_GO_KR_API_KEY']}"
      Hash.from_xml(response_detail_member.body)["response"]["body"]["item"].merge("id" => "#{result_member['deptCd']}-#{result_member['num']}")
    end
  rescue => e
    []
  rescue Exception => e
    []
  end

  private

  def cachable_raw_data
    result = Rails.cache.read("assembly_areas")
    AssemblyJob.perform_async if result.blank?
    result || []
  end
end

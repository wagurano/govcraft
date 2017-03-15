class AssemblyMember < ApplicationRecord
  scope :order_by_origNm, -> { order("case when origNm like '서울%' then 0 when origNm like '비례%' then 2 else 1 end").order(:origNm) }

  def self.refresh!
    ActiveRecord::Base.transaction do
      self.destroy_all
      self.load_data_from_remote.each do |data|
        create! data
      end
    end
  end

  def self.update!
    ActiveRecord::Base.transaction do
      self.load_data_from_remote.each do |data|
        member = self.find_or_create_by!(deptCd: data['deptCd'], num: data['num'])
        member.update_attributes! data
      end
    end
  end

  def self.load_data_from_remote
    return [] if ENV['DATA_GO_KR_API_KEY'].blank?
    response_members = RestClient.get "http://apis.data.go.kr/9710000/NationalAssemblyInfoService/getMemberCurrStateList?numOfRows=400&serviceKey=#{ENV['DATA_GO_KR_API_KEY']}"
    result_members = Hash.from_xml(response_members.body)["response"]["body"]["items"]["item"]
    result_detail_members = result_members.map do |result_member|
      response_detail_member = RestClient.get "http://apis.data.go.kr/9710000/NationalAssemblyInfoService/getMemberDetailInfoList?num=#{result_member['num']}&dept_cd=#{result_member['deptCd']}&serviceKey=#{ENV['DATA_GO_KR_API_KEY']}"
      Hash.from_xml(response_detail_member.body)["response"]["body"]["item"].merge("deptCd" => result_member['deptCd'], "num" => result_member['num'], "jpgLink" => result_member['jpgLink'])
    end
  rescue => e
    []
  rescue Exception => e
    []
  end
end

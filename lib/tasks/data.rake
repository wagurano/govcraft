namespace :data do
  desc '국회의원 데이터가 비어있으면 로드합니다'
  task 'load_once_assembly_members' => :environment do
    if AssemblyMember.all.empty?
      AssemblyMember.refresh!
    end
  end
end

namespace :organizations do
  desc "seed group"
  task 'seed' => :environment do
    Organization.transaction do
      seed(title: '우주당',
        description: '직접 민주주의 프로젝트 정당 우주당입니다. 우리가 주인이 되어 우리의 이야기로 정치하는, 새롭고 즐거운 시도들을 함께 해요!',
        slug: 'wouldyouparty')

      seed(title: '우리가 만드는 대한민국',
        description: '',
        slug: 'urimanna')
    end
  end

  def seed(options)
    slug = options[:slug]
    organization = Organization.find_or_initialize_by slug: slug
    organization.assign_attributes(options)
    organization.save!
  end
end

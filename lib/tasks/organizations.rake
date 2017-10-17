namespace :organizations do
  desc "seed group"
  task 'seed' => :environment do
    Organization.transaction do
      seed(site_name: '우리가 주인이당! Would You Party?',
        title: '우주당',
        description: '직접 민주주의 프로젝트 정당 우주당입니다. 우리가 주인이 되어 우리의 이야기로 정치하는, 새롭고 즐거운 시도들을 함께 해요!',
        slug: 'wouldyouparty',
        slogan: '우리가 주인이 되는 직접 민주주의 프로젝트 정당',
        community_url: 'https://wouldyou.parti.xyz/')

      seed(title: '우리가 만드는 나라',
        description: '',
        slug: 'urimanna',
        slogan: '일상 속에서의 민주주의 실현',
        community_url: 'https://kdemo.parti.xyz/')

      category_seed('urimanna',
        title: '환경',
        slug: 'environment')

      category_seed('urimanna',
        title: '청년',
        slug: 'youth')

      category_seed('urimanna',
        title: '젠더',
        slug: 'gender')

      category_seed('urimanna',
        title: '마을',
        slug: 'village')

      category_seed('urimanna',
        title: '개헌',
        slug: 'changelaw')

      category_seed('urimanna',
        title: '정치',
        slug: 'politics')

      seed(title: '바꿈',
        description: '',
        slug: 'change2020',
        slogan: '세상을 바꾸는 꿈',
        community_url: 'https://change.parti.xyz/')
    end
  end

  def seed(options)
    slug = options[:slug]
    organization = Organization.find_or_initialize_by slug: slug
    organization.assign_attributes(options)
    organization.save!
  end

  def category_seed(organization_slug, options)
    slug = options[:slug]
    organization = Organization.find_by(slug: organization_slug)
    category = ProjectCategory.find_or_initialize_by slug: slug
    category.assign_attributes(options)
    category.organization = organization
    category.save!
  end
end

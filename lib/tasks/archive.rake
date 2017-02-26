namespace :archive do
  desc "특조위 자료 업로드"
  task 'inv_board', [:file_path] => :environment do |t, args|
    xlsx = Roo::Spreadsheet.open args[:file_path]

    archive = Archive.find_by(id: 1)
    archive.documents.where(category_slug: 'inv-documents').destroy_all

    attributes_map = { code: 3, report_date: 6, title: 8,
      recipients: 9, reporter: 10, reviewer: 11,
      open_level: 15, open_desc: 24, open_reclassification: 26}
    attributes_count = 45
    xlsx.sheet(2).each_row_streaming(offset: 1, pad_cells: true) do |row|
      if empty_row?(row, attributes_count)
        break
      end

      row_data = fetch_all(row, attributes_map)

      document = archive.documents.build
      document.user = User.find_by(nickname: '달리')
      document.title = "[#{row_data[:code]}] #{row_data[:title]}"
      document.body = """
        <div class='inv-documents'>
          <p>#{row_data[:title]}</p>
          <ul>
            #{list_item(row_data, '문서번호', :code)}
            #{list_item(row_data, '보고자', :reporter)}
            #{list_item(row_data, '검토자', :reviewer)}
            #{list_item(row_data, '공개구분', :open_level)}
            #{list_item(row_data, '비공개사유', :open_desc)}
            #{list_item(row_data, '공개구분 재분류', :open_reclassification)}
          </ul>
        </div>
      """
      document.media_type = '문서'
      document.content_creator = row_data[:reporter]
      document.content_recipients = row_data[:recipients]
      report_date = row_data[:report_date]
      if report_date.present?
        year, month, day = report_date.split('.')
        document.content_created_date = "#{year}#{month.presence || '00'}#{day.presence || '00'}"
      end
      document.category_slug = 'inv-documents'
      document.save!
    end
  end

  def fetch_all(row, attributes_map)
    Hash[attributes_map.map do |attribute, index|
      [attribute, fetch_data(row, index)]
    end]
  end

  def fetch_data(row, index)
    row[index].try(:formatted_value)
  end

  def empty_row? row, attributes_count
    row[0...attributes_count].all? do |cell|
      cell.nil? or cell.formatted_value.try(:strip).blank?
    end
  end

  def list_item(row_data, label, attribute)
    "<li>#{label}: #{row_data[attribute]}</li>" if row_data[attribute].present?
  end
end

namespace :archive do
  INV_BOARD_FIELDS = %i(
    x part_no part_name code x
    doc_no report_date doc_type title recipients
    reporter reviewer has_attachment status doc_kind
    open_type x x x x
    x x x x open_level_desc
    x open_retype x x x
    x x x x x
    open_relevel_desc partial_open_redaction x prod_code_no x
    x task_card_name task_name task_storaging_period x
  )
  INV_BOARD_FIELD_MAP = Hash[INV_BOARD_FIELDS.each_with_index.map do |f, i|
    next if f == :x
    [f, i]
  end.compact]
  desc "아카이브에 특조위 자료 업로드"
  task 'sewol:inv_board:to_archive_documents', [:file_path] => :environment do |t, args|
    xlsx = Roo::Spreadsheet.open args[:file_path]

    Archive::SewolInvDocument.destroy_all
    Archive::SewolInvDocument.connection.execute("ALTER TABLE archive_sewol_inv_documents AUTO_INCREMENT = 1")

    archive = Archive.find_by(id: 1)
    archive.documents.where(category_slug: 'inv-documents').destroy_all
    id = ArchiveDocument.maximum(:id)
    ArchiveDocument.connection.execute("ALTER TABLE archive_documents AUTO_INCREMENT = #{id + 1}")

    xlsx.sheet(2).each_row_streaming(offset: 1, pad_cells: true) do |row|
      if empty_row?(row, INV_BOARD_FIELDS.length)
        break
      end

      row_data = fetch_all(row, INV_BOARD_FIELD_MAP)

      document = archive.documents.build
      document.user = User.find_by(nickname: '달리')
      document.title = "[#{row_data[:code]}] #{row_data[:title]}"
      document.body = "<p>#{row_data[:title]}</p>"
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

      sewol_document = Archive::SewolInvDocument.new
      sewol_document.assign_attributes(row_data)
      sewol_document.archive_document = document
      sewol_document.save!
    end
  end

  def fetch_all(row, fields)
    Hash[fields.map do |attribute, index|
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

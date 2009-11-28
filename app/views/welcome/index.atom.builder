atom_feed do |feed|
  title = "#{AppConfig.domain} - #{t("activerecord.models.questions")}"

  if current_languages
    title += " category: #{@category}"
  end

  tags = params[:tags]
  if tags && !tags.empty?
    title += " tags: #{tags.kind_of?(String) ? tags : tags.join(", ")}"
  end

  if @langs_conds
    if @lang_conds.kind_of?(Array)
      title += " languages: #{@langs_conds.join(", ")}"
    else
      title += " languages: #{@langs_conds}"
    end
  end

  feed.title(title)
  unless @questions.empty?
    feed.updated(@questions.first.updated_at)
  end

  for question in @questions
    next if question.updated_at.blank?
    feed.entry(question, :url => question_url(current_languages, question), :id =>"tag:#{question.id}") do |entry|
      entry.title(question.title)
      entry.content(markdown(question.body), :type => 'html')
      entry.updated(question.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))
      entry.author do |author|
        author.name(question.user.login)
      end
    end
  end
end

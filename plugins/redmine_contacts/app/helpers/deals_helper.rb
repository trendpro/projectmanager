# encoding: utf-8
module DealsHelper
  def collection_for_status_select
    deal_statuses.collect{|s| [s.name, s.id.to_s]}
  end 
  
  def deal_status_options_for_select(select="")    
     options_for_select(collection_for_status_select, select)
  end  
  
  def deals_sum_to_currency(deals_sum)
    deals_sum.collect{|c| content_tag(:span, price_to_currency(c[1], c[0], :symbol => true), :style => "white-space: nowrap;")}.join(' / ').html_safe 
  end
  
  def deal_currency_icon(deal)
    case deal.currency.to_s.upcase
    when 'USD' 
      "icon-money-dollar"
    when 'EUR' 
      "icon-money-euro"
    when 'GBP' 
      "icon-money-pound"
    when 'RUB' 
      "icon-money"
    when 'JPY'
      "icon-money-yen"
    else
      "icon-money"
    end
  end

  def collection_for_currencies_select(default_currency = :usd)
    major_currencies(default_currency)
  end

  def major_currencies(default_currency)
    arr = []
    [default_currency.blank? ? nil : default_currency.to_s, :usd, :eur, :gbp, :rub, :jpy, :chf, :sgd].compact.each do |currency_code|
      currency = Money::Currency.find(currency_code)
      arr << ["#{currency.name} (#{currency.symbol})", currency.iso_code] if currency
    end
    arr.uniq
  end  

  def all_currencies
    Money::Currency.table.inject([]) do |array, (id, attributes)|
      array ||= []
      array << ["#{attributes[:name]}" + (attributes[:symbol].blank? ? "" : " (#{attributes[:symbol]})"), attributes[:iso_code]]
      array
    end.sort{|x, y| x[0] <=> y[0]}
  end  
  
  def price_to_currency(price, currency, options={})
    return '' if price.blank?

    Money.from_float(price, currency).format(options) rescue number_with_delimiter(price, :delimiter => ' ', :precision => 2)
  end
  
  def deal_price(deal)
    price_to_currency(deal.price, deal.currency, :symbol => true).to_s
  end
  
  def deal_statuses
    (!@project.blank? ? @project.deal_statuses : DealStatus.all(:order => "#{DealStatus.table_name}.status_type, #{DealStatus.table_name}.position")) || []
  end  
  
  def remove_contractor_link(contact) 
    link_to(image_tag('delete.png'), 
		  {:controller => "deal_contacts", :action => 'delete', :project_id => @project, :deal_id => @deal, :contact_id => contact}, 
			:remote => true,
      :method => :delete, 
			:confirm => l(:text_are_you_sure),	
			:class  => "delete", :title => l(:button_delete)) if  User.current.allowed_to?(:edit_deals, @project)
  end    
  
  def retrieve_date_range(period)   
    @from, @to = nil, nil
    case period 
    when 'today'
      @from = @to = Date.today
    when 'yesterday'
      @from = @to = Date.today - 1
    when 'current_week'
      @from = Date.today - (Date.today.cwday - 1)%7
      @to = @from + 6
    when 'last_week'
      @from = Date.today - 7 - (Date.today.cwday - 1)%7
      @to = @from + 6
    when '7_days'
      @from = Date.today - 7
      @to = Date.today
    when 'current_month'
      @from = Date.civil(Date.today.year, Date.today.month, 1)
      @to = (@from >> 1) - 1
    when 'last_month'
      @from = Date.civil(Date.today.year, Date.today.month, 1) << 1
      @to = (@from >> 1) - 1
    when '30_days'
      @from = Date.today - 30
      @to = Date.today
    when 'current_year'
      @from = Date.civil(Date.today.year, 1, 1)
      @to = Date.civil(Date.today.year, 12, 31)
    end    
    
    @from, @to = @from, @to + 1 if (@from && @to)
        
  end
  
  def deal_status_tag(deal_status)
    status_tag = content_tag(:span, deal_status.name) 
    content_tag(:span, status_tag, :class => "deal-status tags", :style => "background-color:#{deal_status.color_name};color:white;")
  end  
  
  
  def retrieve_deals_query
    # debugger
    # params.merge!(session[:deals_query])
    # session[:deals_query] = {:project_id => @project.id, :status_id => params[:status_id], :category_id => params[:category_id], :assigned_to_id => params[:assigned_to_id]}
    if params[:status_id] || !params[:period].blank? || !params[:category_id].blank? || !params[:assigned_to_id].blank? 
      session[:deals_query] = {:project_id => (@project ? @project.id : nil), 
                               :status_id => params[:status_id], 
                               :category_id => params[:category_id], 
                               :period => params[:period],
                               :assigned_to_id => params[:assigned_to_id]}
    else
      if api_request? || params[:set_filter] || session[:deals_query].nil? || session[:deals_query][:project_id] != (@project ? @project.id : nil)
        session[:deals_query] = {}
      else
        params.merge!(session[:deals_query])
      end
    end
  end

  def deals_to_csv(deals)
    decimal_separator = l(:general_csv_decimal_separator)
    encoding = 'utf-8'
    export = FCSV.generate(:col_sep => l(:general_csv_separator)) do |csv|
      # csv header fields
      headers = [ "#",
                  l(:field_name, :locale => :en),
                  l(:field_background, :locale => :en),
                  l(:field_currency, :locale => :en),
                  l(:field_price, :locale => :en), 
                  l(:label_crm_probability, :locale => :en), 
                  l(:label_crm_expected_revenue, :locale => :en), 
                  l(:field_due_date, :locale => :en), 
                  l(:field_author, :locale => :en),     
                  l(:field_assigned_to, :locale => :en),     
                  l(:field_status, :locale => :en),
                  l(:field_contact, :locale => :en),
                  l(:field_category, :locale => :en),   
                  l(:field_created_on, :locale => :en),
                  l(:field_updated_on, :locale => :en),
                  ]

      custom_fields = DealCustomField.all
      custom_fields.each {|f| headers << f.name}
      csv << headers.collect {|c| Redmine::CodesetUtil.from_utf8(c.to_s, encoding) }
      # csv lines
      deals.each do |deal|
        fields = [deal.id,
                  deal.name,
                  deal.background,
                  deal.currency,
                  deal.price,
                  deal.probability,
                  deal.expected_revenue,
                  format_date(deal.due_date),
                  deal.author,
                  deal.assigned_to,
                  deal.status,
                  deal.contact,
                  deal.category,
                  format_date(deal.created_on),
                  format_date(deal.updated_on)
                  ]
        custom_fields.each {|f| fields << show_value(deal.custom_value_for(f)) }
        csv << fields.collect {|c| Redmine::CodesetUtil.from_utf8(c.to_s, encoding) }                  
      end
    end
    export
  end

  
  
end

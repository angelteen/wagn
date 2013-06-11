

view :editor do |args|
  set_name = card.cardname.trunk_name
  set_card = Card.fetch(set_name)
  not_set = set_card && set_card.type_id != Card::SetID

  group_options = Account.as_bot { Card.search(:type=>Card::RoleID, :sort=>'name') }

  inheritable = not_set ? false : set_card.inheritable?
  inheriting = inheritable && card.content=='_left'

  item_names = inheriting ? [] : card.item_names

  %{     
    #{ form.hidden_field :content, :class=>'card-content' }
    <div class="perm-editor">
    
      #{ if inheritable; %{
        <div class="perm-inheritance perm-section">
          #{ check_box_tag 'inherit', 'inherit', inheriting }
          <label>
            #{ core_inherit_content args.merge(:target=>'wagn_role') }
            #{ content_tag( :a, :title=>"use left's #{card.cardname.tag} rule") { '?' } }
          </label>
        </div>
      } end }
    
      <div class="perm-group perm-vals perm-section">
        <h5>Groups</h5>
        #{
          group_options.map do |option|
            checked = !!item_names.delete(option.name)
            %{
              <div class="group-option">
                #{ check_box_tag( "#{option.key}-perm-checkbox", option.name, checked, :class=>'perm-checkbox-button'  ) }
                <label>#{ link_to_page option.name, nil, :target=>'wagn_role' }</label>
              </div>
            }
          end * "\n"
        }
      </div>
      
      <div class="perm-indiv perm-vals perm-section">
        <h5>Individuals</h5>
        #{ _render_list :items=>item_names, :extra_css_class=>'perm-indiv-ul' }
      </div>
                
    </div>
  }
end

view :core do |args|
  args[:item] ||= :link
  card.content=='_left' ? core_inherit_content(args) : _final_pointer_type_core(args)
end

view :closed_content do |args|
  card.content=='_left' ? core_inherit_content(args) : _final_pointer_type_closed_content(args)
end

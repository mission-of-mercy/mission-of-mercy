module UsersHelper

  def link_to_help
    request = { user_id:           current_user.id,
                area_id:           current_area_id,
                treatment_area_id: current_treatment_area_id }

    link_to image_tag("need_help.png", class: "no_border"),
      support_requests_path(support_request: request),
      data:   { remote: true },
      method: :post,
      id:     "help_link"
  end

  def user_list
    User.order(:login).map {|u| [u.name, u.login] }.
    sort_by { |x| x[0].split(%r{(?<=\D)(?=\d)|(?<=\d)(?=\D)}).
    map{|x| (x =~ /\A\d+\z/) ? x.to_i : x } }
  end

end

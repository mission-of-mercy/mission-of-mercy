module UsersHelper
  def user_list
    regular_users = User.order(:login).where("user_type <> ?", UserType::ADMIN).
    map {|u| [u.name, u.login] }.
    sort_by { |x| x[0].split(%r{(?<=\D)(?=\d)|(?<=\d)(?=\D)}).
    map{|x| (x =~ /\A\d+\z/) ? x.to_i : x } }

    regular_users + ["- Restricted -"] +
      User.order(:login).where("user_type = ?", UserType::ADMIN).
      map {|u| [u.name, u.login] }
  end
end

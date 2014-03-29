module UsersHelper
  def user_list
    User.order(:login).map {|u| [u.name, u.login] }.
    sort_by { |x| x[0].split(%r{(?<=\D)(?=\d)|(?<=\d)(?=\D)}).
    map{|x| (x =~ /\A\d+\z/) ? x.to_i : x } }
  end
end

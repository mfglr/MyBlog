module UsersHelper
  def first_letters_of_nick_name(user)
    names = user.nick_name.split(" ")
    first_letter_of_names = ""
    i = 0
    while i < names.length && i < 3
      first_letter_of_names += names[i][0].upcase
      i += 1
    end
    first_letter_of_names
  end

  def format_nick_name(user)
    return "@#{user.nick_name}" if user.nick_name.length <= 10
    "@#{user.nick_name[0..9]}..."
  end

  def number_of_published_posts(user)
    user.articles.where(published: true).count
  end
end

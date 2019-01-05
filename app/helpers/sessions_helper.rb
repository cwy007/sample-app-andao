module SessionsHelper
  def log_in(user) # session 中含有 user_id 时，对应的用户为登录状态
    session[:user_id] = user.id # 这就是所谓的用户登录（在 session 中保存 user_id)
  end

  def remember(user) # 更新 database 中的 digest，并在 cookie 中保存 user_id 和 remember_token 的值
    user.remember # 生成 token，然后用 token 生成 digest 保存在数据库中
    cookies.permanent.signed[:user_id] = user.id # 在 cookie 中永久 permanent 保存加密后的 user_id
    cookies.permanent[:remember_token] = user.remember_token # remember_token 为一个虚拟属性
  end

  def current_user?(user) # user 是否为当前登录用户 current_users
    user == current_user # current_user 本质上是一个方法，返回一个 User 实例或返回 nil
  end

  def current_user # 根据 session 和 cookies 中的数据，确定返回 @current_user 或 nil
    if (user_id = session[:user_id]) # 当 server 的 session 中含有 user_id 时
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) # 当前发送请求的 cookie 含有用户 ID 时 user_id
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token]) # remmeber_token 用于让浏览器保持用户的登录状态
        log_in user # 设定 session[:user_id] 的值为 user.id
        @current_user = user # 设定 @current_user 实力变量
      end
    end
  end

  # 根据 session 和 cookies 中的数据是否能确认 @current_user 的信息：true or false
  def logged_in? # current_user 方法的返回值不为 nil 时，返回 true
    !current_user.nil? # current_user 方法，在不能确定 @current_user 的值时，回返回 nil
  end

  def forget(user)
    user.forget # 将 database 中的 user.remember_digest 设为空 nil
    cookies.delete(:user_id) # 删除 cookies 中的数据
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user) # log_out 包含 forget
    session.delete(:user_id) # 删除 session 中的 user_ids
    @current_user = nil # 清空 @current_user
  end

  # 这个方法是在要求用户强制登录后，将用户重定向到原来 get 请求的页面
  def redirect_back_or(default) # 类似于 redirect_back fallback_location: default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url) # 重定向后，清空 session 中缓存的 url 值
  end

  def store_location # 为 get 请求时，在回话 session 中储存原有的链接 original_url
    session[:forwarding_url] = request.original_url if request.get?
  end
end

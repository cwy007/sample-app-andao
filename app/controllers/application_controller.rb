class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper # 将 helper 方法引入到控制器中
end

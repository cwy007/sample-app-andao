class User < ApplicationRecord
  attr_accessor :remember_token # user 的虚拟属性
  before_save { email.downcase! }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  has_secure_password

  class << self
    def digest(string) # 加密 token
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # 当 token 值唯一时，hacker 必须知道 user_id 和 remember_token 才能实现‘会话劫持’
    def new_token # 产生一个随机数
      SecureRandom.urlsafe_base64
    end
  end

  # update_attribute 会跳过验证，直接更新数据；因为无法获取 password 的值，此处必须跳过model验证
  def remember # 生成 token，并更新数据库中的 digest
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token) # 将 token 与数据库中的数据 digest 进行匹配
    return false if remember_token.blank?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget # 将 token 对应的 digest 清空 nil
    update_attribute(:remember_digest, nil)
  end
end

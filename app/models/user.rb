class User < ActiveRecord::Base

  attr_accessor :role

  def master_role?
    role == 'master'
  end

  def user_role?
    role == 'user' || role.blank?
  end

end
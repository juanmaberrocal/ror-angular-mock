# create initial admin user
if User.where(admin: true).count == 0
	user = User.new(username: 'admin', email: 'my.admin@email.com', password: 'password', admin: true)
	user.save! # devise handles password encryption on save
end
docker_build:
	@docker build -t news-admin-app .

docker_push:
	@docker tag news-admin-app jimhsx/admin_app:v4.1.1
	@docker push jimhsx/admin_app:v4.1.1
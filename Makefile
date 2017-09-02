.POSIX:
.SUFFIXES:
MYSQL_HOST      = mysql
MYSQL_DB        = mybb2
MYSQL_ROOT_PASS = root
MYSQL_USER      = mybb2
MYSQL_PASSWORD  = mybb2

env:
	@cp .env.example ./.env
	@sed -i s/MYSQL_HOST=mysql/MYSQL_HOST=$(MYSQL_HOST)/ ./.env
	@sed -i s/MYSQL_DATABASE=mybb2/MYSQL_DATABASE=$(MYSQL_DB)/ ./.env
	@sed -i s/MYSQL_ROOT_PASSWORD=root/MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASS)/ ./.env
	@sed -i s/MYSQL_USER=mybb2/MYSQL_USER=$(MYSQL_USER)/ ./.env
	@sed -i s/MYSQL_PASSWORD=mybb2/MYSQL_PASSWORD=$(MYSQL_PASSWORD)/ ./.env
up: env
	@git clone https://github.com/mybb/mybb2.git web
	@docker-compose build
	@docker-compose up -d
	@docker run --rm -v $(shell pwd)/web:/app --user mybb:mybb composer install --no-interaction
	@sed -i s/DB_HOST=localhost/DB_HOST=$(MYSQL_HOST)/ ./web/.env
	@sed -i s/DB_DATABASE=homestead/DB_DATABASE=$(MYSQL_DB)/ ./web/.env
	@sed -i s/DB_USERNAME=homestead/DB_USERNAME=$(MYSQL_USER)/ ./web/.env
	@sed -i s/DB_PASSWORD=secret/DB_PASSWORD=$(MYSQL_PASSWORD)/ ./web/.env
	@docker-compose exec -T php ./artisan migrate:install
	@docker-compose exec -T php ./artisan migrate
	@docker-compose exec -T php ./artisan db:seed
down:
	@docker-compose down -v
logs:
	@docker-compose logs -f
composer-update:
	@docker run --rm -v $(shell pwd)/web:/app composer update
clean: down
	@rm -f .env
	@rm -Rf data
	@rm -Rf web
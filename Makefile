db-create:
	docker exec -it bank-postgres createdb --username=root --owner=root bank

db-drop:
	docker exec -it bank-postgres dropdb bank

postgres:
	docker run --name bank-postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14-alpine

db-migrate-up:
	migrate -path db/migrations -database "postgresql://root:secret@localhost:5432/bank?sslmode=disable" -verbose up

db-migrate-down:
	migrate -path db/migrations -database "postgresql://root:secret@localhost:5432/bank?sslmode=disable" -verbose down

db-seed:
	cat db/seed.sql | docker exec -i bank-postgres psql -U root -d bank

.PHONY: postgres db-create db-drop db-migrate-up db-migrate-down db-seed
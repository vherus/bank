# Building a bank so Monzo will hire me

Over the next several months I'm going to learn Go and a bunch of cloud infrastructure stuff by building a banking app so Monzo will hire me.

I will make a ton of mistakes and bad judgement calls, but I'll leave it all in here as a complete history. We should celebrate our failures as normal growing pains.

## Architecture decisions

I imagine this will grow to include CQRS, micro-services, event streaming etc., but for now I've got a simple ERD and Postgres database. I'll scale it up as I go.

![](./_assets/erd.png)

I don't have a balance on the account entity, I'm presuming that's a calculated value based on a transaction history. I'll figure out how to cache that or something later.


docker run --name bank-postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14-alpine
docker exec -it bank-postgres psql -U root

migrate create -ext sql -dir db/migrations -seq init_schema
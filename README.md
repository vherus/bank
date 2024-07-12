# Building a bank

Over the next several months I'm going to learn Go and a bunch of cloud infrastructure stuff by building a banking app.

I will make a ton of mistakes and bad judgement calls, but I'll leave it all in here as a complete history. We should celebrate our failures as normal growing pains.

## Architecture decisions

I imagine this will grow to include CQRS, micro-services, event streaming etc., but for now I've got a simple ERD and Postgres database. I'll scale it up as I go.

![](./_assets/erd.png)

I don't have a balance on the account entity, I'm presuming that's a calculated value based on a transaction history. I'll figure out how to cache that or something later.

## Notes

Make a new migration: `migrate create -ext sql -dir db/migrations -seq init_schema`
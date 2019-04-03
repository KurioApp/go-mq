[![GoDoc](https://godoc.org/github.com/KurioApp/go-mq?status.svg)](https://godoc.org/github.com/KurioApp/go-mq)
# go-mq

MQ is go API to communicate with messaging queue system.

## Index
- [Getting Started](#getting-started)
- [Support and Contribution](#support-and-contribution)
- [Example](#example)

### Getting Started

To use this library, you could simple download it with:
```
go get -u -v github.com/KurioApp/go-mq
```
### Support and Contribution

To contribute to this project, you could submit a Pull Request (PR) or just file an [issue](https://github.com/KurioApp/go-mq/issues/new).

### Example

MQ is a go API to communicate with messaging queue system like RabbitMQ, Google Pubsub, Redis Pubsub, Kafka etc. But unfortunately, currently we still support only for Google Pubsub. 

#### Google Pubsub
To use the Google Pubsub messaging queue system, you could do it like this examples below. 

```go
package main

import (
	"context"
	"log"

	mq "github.com/KurioApp/go-mq"
	pubsub "github.com/KurioApp/go-mq/pubsub"
	"google.golang.org/api/option"
)

func main() {
	ctx := context.Background()

	pbClient, err := pubsub.New(ctx, "pubsub-project-id", option.WithCredentialsFile("./credential_file.json"))
	if err != nil {
		log.Fatal(err)
	}

	// Ensure the topic is exist
	topic, err := pbClient.EnsureTopic(context.TODO(), "topic-name")
	if err != nil {
		log.Fatal(err)
	}

	// Publish a Message to Pubsub
	pbClient.Publish("topic-name", []byte(`{"message": "hello world"}`))

	// Ensure the susbcription is exist in the topic
	_, err = pbClient.EnsureSubscription(context.TODO(), topic, "subscription-id")
	if err != nil {
		log.Fatal(err)
	}

	// Subscribe to a channel
	go func() {
		pbClient.Subscribe(context.Background(), "subscription-id", &IncomingMsgHandler{})
	}()
}

type IncomingMsgHandler struct {
}

// Handle is implementation of Handler interface from mq.Handler
func (i *IncomingMsgHandler) Handle(m mq.Message) {
	// Handle Incoming Message Here
}
```

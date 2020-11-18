# Flutter: Working with bloc with simple CRUD
Bloc is business logic component to maintain the state of data, there are various ways to handle bloc pattern in flutter, and this is one of them.

But every bloc pattern will contain following terms:
1. Stream Controller: It is nothing but a pipe which is flow of data
2. Sink: Sink is the input for that pipe(stream controller)
3. Stream: Stream is the output for that pipe(stream controller)

In the following example, i've taken two stream controllers.
_eventStreamController: which handles, what type of event we need to perform
_stateStreamController: which handles, actual data of user.

Flutter Info:
## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

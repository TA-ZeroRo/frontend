# State Management Guide

| Situation                            | Recommended Provider    | Use cases                                        |
| ------------------------------------ | ----------------------- | ------------------------------------------------ |
| Simple values (number, string, bool) | `StateProvider`         | Counter, switches, simple settings               |
| Complex synchronous state            | `NotifierProvider`      | User info, shopping cart, form data              |
| Asynchronous data handling           | `AsyncNotifierProvider` | API calls, database CRUD                         |
| One-off API calls                    | `FutureProvider`        | Initial configuration loading, simple data fetch |
| Real-time streams                    | `StreamProvider`        | Chat, real-time notifications, WebSocket         |

---

## Detailed examples by Provider

### 1. StateProvider — Simple state management

**When to use**

* Managing primitive types (int, String, bool)
* Simple UI state (toggle, counter, etc.)

```dart
enum ThemeMode { light, dark }
final counterProvider = StateProvider<int>((ref) => 0);
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

class SimpleCounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

### 2. NotifierProvider — Complex synchronous state

**When to use**

* Managing complex object state
* State changes with business logic
* State with multiple fields

```dart
// domain/model/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    @Default(true) bool isActive,
  }) = _User;
}

class UserNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  void login(String id, String name, String email) {
    state = User(id: id, name: name, email: email);
  }
  void logout() { state = null; }
  void updateEmail(String newEmail) {
    if (state != null) {
      state = state!.copyWith(email: newEmail);
    }
  }
  void toggleActive() {
    if (state != null) {
      state = state!.copyWith(isActive: !state!.isActive);
    }
  }
}

final userProvider = NotifierProvider<UserNotifier, User?>(UserNotifier.new);

class UserProfileWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return ElevatedButton(
        onPressed: () => ref.read(userProvider.notifier).login('1', 'John Doe', 'john@example.com'),
        child: Text('Login'),
      );
    }
    return Column(
      children: [
        Text('Name: ${user.name}'),
        Text('Email: ${user.email}'),
        Text('Status: ${user.isActive ? 'Active' : 'Inactive'}'),
        ElevatedButton(
          onPressed: () => ref.read(userProvider.notifier).toggleActive(),
          child: Text('Toggle Status'),
        ),
        ElevatedButton(
          onPressed: () => ref.read(userProvider.notifier).logout(),
          child: Text('Logout'),
        ),
      ],
    );
  }
}
```

### 3. AsyncNotifierProvider — Asynchronous state management

**When to use**

* State that involves API calls
* Database CRUD operations
* Cases requiring loading/error handling

```dart
// domain/model/todo.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    @Default(false) bool isCompleted,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

class TodosAsyncNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    return await _fetchTodos();
  }
  Future<List<Todo>> _fetchTodos() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      Todo(id: '1', title: 'Learn Flutter'),
      Todo(id: '2', title: 'Master Riverpod'),
    ];
  }
  Future<void> addTodo(String title) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
      );
      await Future.delayed(Duration(milliseconds: 500));
      final currentTodos = state.value ?? [];
      return [...currentTodos, newTodo];
    });
  }
  Future<void> toggleTodo(String todoId) async {
    final currentTodos = state.value ?? [];
    final updatedTodos = currentTodos.map((todo) {
      if (todo.id == todoId) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();
    state = AsyncValue.data(updatedTodos);
    try {
      await Future.delayed(Duration(milliseconds: 300));
    } catch (error) {
      state = AsyncValue.data(currentTodos);
      rethrow;
    }
  }
  Future<void> deleteTodo(String todoId) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(Duration(milliseconds: 300));
      final currentTodos = state.value ?? [];
      return currentTodos.where((todo) => todo.id != todoId).toList();
    });
  }
}

final todosProvider = AsyncNotifierProvider<TodosAsyncNotifier, List<Todo>>(TodosAsyncNotifier.new);

class TodoListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTodos = ref.watch(todosProvider);
    return asyncTodos.when(
      data: (todos) => Column(
        children: [
          ElevatedButton(
            onPressed: () => ref.read(todosProvider.notifier).addTodo('New Todo'),
            child: Text('Add Todo'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) => ref.read(todosProvider.notifier).toggleTodo(todo.id),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => ref.read(todosProvider.notifier).deleteTodo(todo.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Column(
        children: [
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () => ref.invalidate(todosProvider),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
```

### 4. FutureProvider — One-off asynchronous tasks

**When to use**

* Loading configuration at app startup
* One-time API calls
* Loading data that has dependencies

```dart
// domain/model/app_config.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
class AppConfig with _$AppConfig {
  const factory AppConfig({
    required String apiBaseUrl,
    required String appVersion,
    required List<String> features,
  }) = _AppConfig;
  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);
}

final configProvider = FutureProvider<AppConfig>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  return AppConfig(
    apiBaseUrl: 'https://api.example.com',
    appVersion: '1.0.0',
    features: ['feature1', 'feature2'],
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(configProvider).value;
  if (config == null) {
    throw Exception('Config not loaded yet');
  }
  return ApiClient(baseUrl: config.apiBaseUrl);
});

class AppInitWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsync = ref.watch(configProvider);
    return configAsync.when(
      data: (config) => Column(
        children: [
          Text('App Version: ${config.appVersion}'),
          Text('API URL: ${config.apiBaseUrl}'),
          Text('Features: ${config.features.join(', ')}'),
        ],
      ),
      loading: () => Column(
        children: [
          CircularProgressIndicator(),
          Text('Loading configuration...'),
        ],
      ),
      error: (error, stack) => Column(
        children: [
          Text('Failed to load config: $error'),
          ElevatedButton(
            onPressed: () => ref.invalidate(configProvider),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
```

### 5. StreamProvider — Real-time data

**When to use**

* Real-time chat
* Notification systems
* WebSocket connections
* Firebase real-time data

```dart
// domain/model/chat_message.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String text,
    required String sender,
    required DateTime timestamp,
  }) = _ChatMessage;
  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}

class ChatService {
  Stream<List<ChatMessage>> watchMessages() {
    return Stream.periodic(Duration(seconds: 3), (count) {
      return [
        ChatMessage(
          id: count.toString(),
          text: 'Message $count',
          sender: 'User ${count % 2 + 1}',
          timestamp: DateTime.now(),
        ),
      ];
    }).asyncMap((newMessages) async {
      return [..._messages, ...newMessages];
    });
  }
  static final List<ChatMessage> _messages = [];
}

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());
final messagesStreamProvider = StreamProvider<List<ChatMessage>>((ref) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.watchMessages();
});

class ChatWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesStreamProvider);
    return messagesAsync.when(
      data: (messages) => ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            title: Text(message.text),
            subtitle: Text('${message.sender} - ${message.timestamp}'),
          );
        },
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Column(
        children: [
          Text('Connection error: $error'),
          ElevatedButton(
            onPressed: () => ref.invalidate(messagesStreamProvider),
            child: Text('Reconnect'),
          ),
        ],
      ),
    );
  }
}

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});
final apiServiceProvider = Provider<ApiService>((ref) {
  final config = ref.watch(configProvider).value;
  return ApiService(config?.apiBaseUrl ?? 'https://fallback.com');
});

final userStatusProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider);
  if (user == null) return 'Not logged in';
  if (!user.isActive) return 'Inactive user';
  return 'Active user: ${user.name}';
});

class ServiceExampleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStatus = ref.watch(userStatusProvider);
    final apiService = ref.watch(apiServiceProvider);
    return Column(
      children: [
        Text('Status: $userStatus'),
        ElevatedButton(
          onPressed: () async {
            final data = await apiService.fetchData();
            print(data);
          },
          child: Text('Fetch Data'),
        ),
      ],
    );
  }
}
```

---

## Practical patterns and Best Practices

### 0. Domain model usage guideline

**Important**: Place all data models in the `domain/model/` directory following Clean Architecture.

```dart
// domain/model/user.dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
  }) = _User;
}

// Using in a Provider
import 'package:your_app/domain/model/user.dart';
final userProvider = NotifierProvider<UserNotifier, User?>(UserNotifier.new);
```

### 1. Folders and files

Create a Riverpod folder named `state`, and implement providers in files with the suffix `_controller.dart`.

**Naming convention for controller files:**
- File name should reflect the **state/domain** being managed, not the page name
- Examples: `ranking_controller.dart` (manages Ranking data), `profile_controller.dart` (manages Profile state)

If you want to use mock data, create a `Mock` folder under `state` and put mock data files there.

### 2. Provider naming convention

```dart
final userProvider = NotifierProvider<UserNotifier, User?>(UserNotifier.new);
final todosProvider = AsyncNotifierProvider<TodosNotifier, List<Todo>>(TodosNotifier.new);
final configProvider = FutureProvider<AppConfig>((ref) => ...);
```

---

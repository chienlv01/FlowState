import 'package:flutter/material.dart';
import 'package:state_management/state_management.dart';

// Models
class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Priority priority;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
    this.priority = Priority.medium,
  });

  Todo copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? completedAt,
    Priority? priority,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      priority: priority ?? this.priority,
    );
  }
}

enum Priority { low, medium, high }

// State
class TodoState {
  final List<Todo> todos;
  final bool isLoading;
  final String? error;
  final Filter currentFilter;

  TodoState({
    this.todos = const [],
    this.isLoading = false,
    this.error,
    this.currentFilter = Filter.all,
  });

  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
    String? error,
    Filter? currentFilter,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  List<Todo> get filteredTodos {
    switch (currentFilter) {
      case Filter.all:
        return todos;
      case Filter.completed:
        return todos.where((todo) => todo.isCompleted).toList();
      case Filter.active:
        return todos.where((todo) => !todo.isCompleted).toList();
    }
  }
}

enum Filter { all, completed, active }

// Provider
class TodoProvider extends StateProvider<TodoState> with AutoDispose<TodoState> {
  TodoProvider() : super(() => TodoState());

  void addTodo(BuildContext context, String title, String description, Priority priority) {
    read(context).update((state) {
      final todos = [...state.todos];
      todos.add(Todo(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
        priority: priority,
      ));
      return state.copyWith(todos: todos);
    });
  }

  void toggleTodo(BuildContext context, String id) {
    read(context).update((state) {
      final todos = state.todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(
            isCompleted: !todo.isCompleted,
            completedAt: !todo.isCompleted ? DateTime.now() : null,
          );
        }
        return todo;
      }).toList();
      return state.copyWith(todos: todos);
    });
  }

  void updateTodo(BuildContext context, String id, {
    String? title,
    String? description,
    Priority? priority,
  }) {
    read(context).update((state) {
      final todos = state.todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(
            title: title,
            description: description,
            priority: priority,
          );
        }
        return todo;
      }).toList();
      return state.copyWith(todos: todos);
    });
  }

  void removeTodo(BuildContext context, String id) {
    read(context).update((state) {
      final todos = state.todos.where((todo) => todo.id != id).toList();
      return state.copyWith(todos: todos);
    });
  }

  void setFilter(BuildContext context, Filter filter) {
    read(context).update((state) => state.copyWith(currentFilter: filter));
  }

  static TodoProvider of() {
    return Store.instance.provider<TodoState>() as TodoProvider;
  }
}

// Selector for filtered todos
class FilteredTodosSelector extends StateSelector<TodoState, List<Todo>> {
  FilteredTodosSelector({
    super.key,
    required Widget Function(BuildContext context, List<Todo> selectedState) builder,
  }) : super(
    selector: (state) => state.filteredTodos,
    builder: builder,
  );
}

// Main App
void main() {
  final todoProvider = TodoProvider();
  Store.instance.register<TodoState>(todoProvider);
  


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StateContainer(
        child: TodoScreen(),
      ),
    );
  }
}

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: const [FilterButton()],
      ),
      body: Column(
        children: const [
          Expanded(child: TodoList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder<TodoState>(
      builder: (context, state) {
        return PopupMenuButton<Filter>(
          initialValue: state.currentFilter,
          onSelected: (filter) {
            TodoProvider.of().setFilter(context, filter);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: Filter.all,
              child: Text('All'),
            ),
            const PopupMenuItem(
              value: Filter.active,
              child: Text('Active'),
            ),
            const PopupMenuItem(
              value: Filter.completed,
              child: Text('Completed'),
            ),
          ],
        );
      },
    );
  }
}

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Priority _priority = Priority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Priority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: Priority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _priority = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              TodoProvider.of().addTodo(
                context,
                _titleController.text,
                _descriptionController.text,
                _priority,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return FilteredTodosSelector(
      builder: (context, filteredTodos) {
        if (filteredTodos.isEmpty) {
          return const Center(
            child: Text('No todos yet. Add some!'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredTodos.length,
          itemBuilder: (context, index) {
            final todo = filteredTodos[index];
            return TodoItem(todo: todo);
          },
        );
      },
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        TodoProvider.of().removeTodo(context, todo.id);
      },
      child: Card(
        child: ExpansionTile(
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) {
              TodoProvider.of().toggleTodo(context, todo.id);
            },
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPriorityColor(todo.priority),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  todo.priority.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Created: ${_formatDate(todo.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          children: [
            if (todo.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(todo.description),
              ),
            if (todo.completedAt != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Text(
                  'Completed: ${_formatDate(todo.completedAt!)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
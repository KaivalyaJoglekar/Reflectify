import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reflectify/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskManagementScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onTaskComplete;
  final Function(Task) onTaskDelete;
  final Function(Task, Task) onTaskReorder;
  final Function(Task) onTaskEdit;

  const TaskManagementScreen({
    super.key,
    required this.tasks,
    required this.onTaskComplete,
    required this.onTaskDelete,
    required this.onTaskReorder,
    required this.onTaskEdit,
  });

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Work',
    'Personal',
    'Projects',
    'Study',
    'Health',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Task> get _filteredTasks {
    var tasks = widget.tasks;
    if (_selectedCategory != 'All') {
      tasks = tasks.where((t) => t.category == _selectedCategory).toList();
    }

    switch (_tabController.index) {
      case 0: // All
        return tasks;
      case 1: // Active
        return tasks.where((t) => !t.isCompleted).toList();
      case 2: // Completed
        return tasks.where((t) => t.isCompleted).toList();
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildCategoryFilter(),
            const SizedBox(height: 16),
            _buildTabBar(),
            const SizedBox(height: 16),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Task Manager',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterOptions(),
              ),
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () => _showSortOptions(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white.withOpacity(0.3),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (index) => setState(() {}),
        indicator: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Active'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    final filteredTasks = _filteredTasks;

    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredTasks.length,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final task = filteredTasks[oldIndex];
        final targetTask = filteredTasks[newIndex];
        widget.onTaskReorder(task, targetTask);
      },
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return _buildTaskCard(task, index);
      },
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    final priorityColor = _getPriorityColor(task.priority);

    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => widget.onTaskEdit(task),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => widget.onTaskDelete(task),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: priorityColor.withOpacity(0.5), width: 1.5),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.drag_indicator, color: Colors.white.withOpacity(0.3)),
              const SizedBox(width: 8),
              Checkbox(
                value: task.isCompleted,
                onChanged: (val) => widget.onTaskComplete(task),
                activeColor: priorityColor,
              ),
            ],
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _buildChip(_getPriorityLabel(task.priority), priorityColor),
                  _buildChip(task.category, Colors.blue),
                  if (task.deadline != null)
                    _buildChip(
                      DateFormat('MMM d').format(task.deadline!),
                      Colors.orange,
                    ),
                  if (task.hasReminder)
                    Icon(
                      Icons.notifications_active,
                      size: 16,
                      color: Colors.yellow[700],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'HIGH';
      case 2:
        return 'MED';
      case 3:
        return 'LOW';
      default:
        return '';
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Options',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.priority_high),
              title: const Text('By Priority'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('By Deadline'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('By Category'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Alphabetical'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Date Created'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.priority_high),
              title: const Text('Priority'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

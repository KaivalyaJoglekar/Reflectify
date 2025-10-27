import 'package:flutter/material.dart';
import 'package:reflectify/models/project_model.dart';
import 'package:reflectify/models/task_model.dart';

class ProjectBoardScreen extends StatefulWidget {
  final List<Project> projects;
  final List<Task> tasks;
  final Function(Task, ProjectStatus) onTaskStatusChange;
  final Function(Project) onProjectTap;
  final VoidCallback onAddProject;

  const ProjectBoardScreen({
    super.key,
    required this.projects,
    required this.tasks,
    required this.onTaskStatusChange,
    required this.onProjectTap,
    required this.onAddProject,
  });

  @override
  State<ProjectBoardScreen> createState() => _ProjectBoardScreenState();
}

class _ProjectBoardScreenState extends State<ProjectBoardScreen> {
  Project? _selectedProject;

  @override
  void initState() {
    super.initState();
    if (widget.projects.isNotEmpty) {
      _selectedProject = widget.projects.first;
    }
  }

  List<Task> _getTasksForProject(Project project) {
    return widget.tasks
        .where((task) => project.taskIds.contains(task.id))
        .toList();
  }

  List<Task> _getTasksByStatus(Project project, ProjectStatus status) {
    final projectTasks = _getTasksForProject(project);
    return projectTasks.where((task) {
      switch (status) {
        case ProjectStatus.todo:
          return !task.isCompleted && task.projectName == project.name;
        case ProjectStatus.inProgress:
          return !task.isCompleted && task.projectName == project.name;
        case ProjectStatus.done:
          return task.isCompleted;
      }
    }).toList();
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
            if (widget.projects.isNotEmpty) _buildProjectSelector(),
            const SizedBox(height: 20),
            if (_selectedProject != null)
              Expanded(child: _buildKanbanBoard(_selectedProject!))
            else
              _buildEmptyState(),
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
            'Project Boards',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: widget.onAddProject,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectSelector() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.projects.length,
        itemBuilder: (context, index) {
          final project = widget.projects[index];
          final isSelected = project.id == _selectedProject?.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedProject = project;
              });
            },
            child: Container(
              width: 180,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? project.color
                      : Colors.white.withOpacity(0.5),
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: project.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: project.color.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          '${project.progress}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: project.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${project.taskIds.length} tasks',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKanbanBoard(Project project) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildColumn(
            'To Do',
            ProjectStatus.todo,
            project,
            const Color(0xFF8A5DF4),
          ),
        ),
        Expanded(
          child: _buildColumn(
            'Doing',
            ProjectStatus.inProgress,
            project,
            const Color(0xFFF4A261),
          ),
        ),
        Expanded(
          child: _buildColumn(
            'Done',
            ProjectStatus.done,
            project,
            const Color(0xFF06D6A0),
          ),
        ),
      ],
    );
  }

  Widget _buildColumn(
    String title,
    ProjectStatus status,
    Project project,
    Color color,
  ) {
    final tasks = _getTasksByStatus(project, status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.5), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${tasks.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: tasks.isEmpty
                ? _buildEmptyColumn()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskCard(tasks[index], status);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, ProjectStatus currentStatus) {
    return Draggable<Map<String, dynamic>>(
      data: {'task': task, 'currentStatus': currentStatus},
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(opacity: 0.8, child: _buildTaskCardContent(task)),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildTaskCardContent(task),
      ),
      child: DragTarget<Map<String, dynamic>>(
        onAcceptWithDetails: (details) {
          final data = details.data;
          final draggedTask = data['task'] as Task;
          // Future: Implement drag-and-drop between columns
          // final fromStatus = data['currentStatus'] as ProjectStatus;
          if (draggedTask.id != task.id) {
            // Handle reordering within same column
          }
        },
        builder: (context, candidateData, rejectedData) {
          return _buildTaskCardContent(task);
        },
      ),
    );
  }

  Widget _buildTaskCardContent(Task task) {
    final priorityColor = _getPriorityColor(task.priority);

    return Container(
      width: 120,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: priorityColor.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              task.description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.5),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getPriorityLabel(task.priority),
                  style: TextStyle(
                    fontSize: 9,
                    color: priorityColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              if (task.deadline != null)
                Icon(
                  Icons.event,
                  size: 12,
                  color: Colors.white.withOpacity(0.4),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyColumn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_task, size: 32, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 8),
          Text(
            'No tasks',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No projects yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: widget.onAddProject,
              icon: const Icon(Icons.add),
              label: const Text('Create Project'),
            ),
          ],
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
}

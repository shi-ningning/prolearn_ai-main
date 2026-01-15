import { Router } from 'express';
import * as taskController from '../controllers/task.controller';
import { authenticate } from '../middleware/auth';

const router = Router();

// All task routes require authentication
router.use(authenticate);

/**
 * @route   GET /api/tasks
 * @desc    List user tasks
 * @access  Private
 */
router.get('/', taskController.listTasks);

/**
 * @route   POST /api/tasks
 * @desc    Create new task
 * @access  Private
 */
router.post('/', taskController.createTask);

/**
 * @route   GET /api/tasks/:id
 * @desc    Get task details
 * @access  Private
 */
router.get('/:id', taskController.getTask);

/**
 * @route   PUT /api/tasks/:id
 * @desc    Update task
 * @access  Private
 */
router.put('/:id', taskController.updateTask);

/**
 * @route   DELETE /api/tasks/:id
 * @desc    Delete task
 * @access  Private
 */
router.delete('/:id', taskController.deleteTask);

/**
 * @route   PATCH /api/tasks/:id/complete
 * @desc    Mark task as complete
 * @access  Private
 */
router.patch('/:id/complete', taskController.completeTask);

export default router;

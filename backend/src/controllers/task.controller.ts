import { Request, Response } from 'express';

export const listTasks = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const createTask = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const getTask = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const updateTask = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const deleteTask = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const completeTask = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

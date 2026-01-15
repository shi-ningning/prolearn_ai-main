import { Request, Response } from 'express';

export const listProjects = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const createProject = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const getProject = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const updateProject = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

export const deleteProject = async (req: Request, res: Response): Promise<void> => {
  res.status(501).json({
    success: false,
    error: { code: 'NOT_IMPLEMENTED', message: 'Endpoint not yet implemented' }
  });
};

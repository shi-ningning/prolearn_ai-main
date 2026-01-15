import mongoose, { Schema, Document } from 'mongoose';

export interface IProject extends Document {
  userId: string;
  title: string;
  description?: string;
  status: 'active' | 'completed' | 'archived';
  category: string;
  progress: number; // 0-100
  startDate: Date;
  endDate?: Date;
  tasks: string[]; // Task IDs
  tags: string[];
  createdAt: Date;
  updatedAt: Date;
}

const ProjectSchema: Schema = new Schema(
  {
    userId: {
      type: String,
      required: true,
      index: true,
    },
    title: {
      type: String,
      required: true,
      trim: true,
    },
    description: {
      type: String,
      trim: true,
    },
    status: {
      type: String,
      enum: ['active', 'completed', 'archived'],
      default: 'active',
    },
    category: {
      type: String,
      required: true,
      trim: true,
    },
    progress: {
      type: Number,
      min: 0,
      max: 100,
      default: 0,
    },
    startDate: {
      type: Date,
      default: Date.now,
    },
    endDate: {
      type: Date,
    },
    tasks: [{
      type: String,
    }],
    tags: [{
      type: String,
      trim: true,
    }],
  },
  {
    timestamps: true,
    collection: 'Projects' // Use exact collection name in MongoDB
  }
);

// Indexes for better query performance
ProjectSchema.index({ userId: 1, status: 1 });
ProjectSchema.index({ userId: 1, createdAt: -1 });
ProjectSchema.index({ category: 1 });

export default mongoose.model<IProject>('Project', ProjectSchema);

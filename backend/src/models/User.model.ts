import mongoose, { Schema, Document } from 'mongoose';

export interface IUser extends Document {
  uid: string; // Firebase UID
  email: string;
  displayName?: string;
  photoURL?: string;
  role: 'student' | 'teacher' | 'admin';
  preferences: {
    language: string;
    theme: string;
    notifications: boolean;
  };
  progress: {
    totalTasksCompleted: number;
    totalStudyHours: number;
    currentStreak: number;
    longestStreak: number;
  };
  createdAt: Date;
  updatedAt: Date;
  lastLoginAt?: Date;
}

const UserSchema: Schema = new Schema(
  {
    uid: {
      type: String,
      required: true,
      unique: true,
      index: true,
    },
    email: {
      type: String,
      // required: true,  // Commented out - email is now optional for signup
      unique: true,
      lowercase: true,
      trim: true,
    },
    displayName: {
      type: String,
      trim: true,
    },
    photoURL: {
      type: String,
    },
    role: {
      type: String,
      enum: ['student', 'teacher', 'admin'],
      default: 'student',
    },
    preferences: {
      language: {
        type: String,
        default: 'en',
      },
      theme: {
        type: String,
        default: 'light',
      },
      notifications: {
        type: Boolean,
        default: true,
      },
    },
    progress: {
      totalTasksCompleted: {
        type: Number,
        default: 0,
      },
      totalStudyHours: {
        type: Number,
        default: 0,
      },
      currentStreak: {
        type: Number,
        default: 0,
      },
      longestStreak: {
        type: Number,
        default: 0,
      },
    },
    lastLoginAt: {
      type: Date,
    },
  },
  {
    timestamps: true,
    collection: 'Users' // Use exact collection name in MongoDB
  }
);

// Indexes for better query performance
UserSchema.index({ email: 1 });
UserSchema.index({ role: 1 });
UserSchema.index({ createdAt: -1 });

export default mongoose.model<IUser>('User', UserSchema);

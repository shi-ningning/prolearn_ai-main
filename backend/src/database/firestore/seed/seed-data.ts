/**
 * Seed data script for Firestore
 * Run this to populate the database with initial data
 */

import * as admin from 'firebase-admin';

// Initialize Firebase Admin
admin.initializeApp();

const db = admin.firestore();

/**
 * Sample syllabi data
 */
const sampleSyllabi = [
  {
    title: 'Introduction to Computer Science',
    description: 'Fundamentals of programming and computational thinking',
    courseCode: 'CS101',
    topics: [
      {
        id: 'topic-1',
        title: 'Introduction to Programming',
        description: 'Basic programming concepts and syntax',
        order: 1
      },
      {
        id: 'topic-2',
        title: 'Data Types and Variables',
        description: 'Understanding different data types',
        order: 2
      },
      {
        id: 'topic-3',
        title: 'Control Structures',
        description: 'If statements, loops, and conditionals',
        order: 3
      },
      {
        id: 'topic-4',
        title: 'Functions and Methods',
        description: 'Creating reusable code blocks',
        order: 4
      }
    ]
  },
  {
    title: 'Web Development Fundamentals',
    description: 'HTML, CSS, and JavaScript basics',
    courseCode: 'WEB101',
    topics: [
      {
        id: 'topic-1',
        title: 'HTML Basics',
        description: 'Structure and semantic HTML',
        order: 1
      },
      {
        id: 'topic-2',
        title: 'CSS Styling',
        description: 'Styling web pages with CSS',
        order: 2
      },
      {
        id: 'topic-3',
        title: 'JavaScript Fundamentals',
        description: 'Client-side programming with JavaScript',
        order: 3
      },
      {
        id: 'topic-4',
        title: 'Responsive Design',
        description: 'Creating mobile-friendly websites',
        order: 4
      }
    ]
  },
  {
    title: 'Database Management Systems',
    description: 'Introduction to databases and SQL',
    courseCode: 'DB101',
    topics: [
      {
        id: 'topic-1',
        title: 'Database Concepts',
        description: 'Understanding databases and DBMS',
        order: 1
      },
      {
        id: 'topic-2',
        title: 'SQL Queries',
        description: 'Writing SELECT, INSERT, UPDATE, DELETE',
        order: 2
      },
      {
        id: 'topic-3',
        title: 'Data Modeling',
        description: 'Entity-relationship diagrams',
        order: 3
      },
      {
        id: 'topic-4',
        title: 'Normalization',
        description: 'Database design best practices',
        order: 4
      }
    ]
  }
];

/**
 * Seed syllabi collection
 */
async function seedSyllabi() {
  console.log('🌱 Seeding syllabi...');
  
  for (const syllabus of sampleSyllabi) {
    const docRef = await db.collection('syllabi').add({
      ...syllabus,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
    
    console.log(`✅ Created syllabus: ${syllabus.title} (${docRef.id})`);
  }
}

/**
 * Main seed function
 */
async function main() {
  try {
    console.log('🚀 Starting database seeding...\n');
    
    await seedSyllabi();
    
    console.log('\n✅ Database seeding completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding database:', error);
    process.exit(1);
  }
}

// Run seeding
main();

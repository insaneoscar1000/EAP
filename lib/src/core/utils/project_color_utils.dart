import 'package:flutter/material.dart';

/// A utility class to generate consistent colors for projects based on the app's color scheme
class ProjectColorUtils {
  // Map to store project name to color associations
  static final Map<String, Color> _projectColors = {};
  
  // List of predefined colors used consistently throughout the app
  static final List<Color> _colors = [
    Color(0xFF7E8C76),  // Green - used for process steps in EA Amendment
    Color(0xFF0F6358),  // Dark teal - used in Section 24G and Scoping EIR
    Color(0xFFD9A48E),  // Light brown - used for PPP in EA Amendment
    Color(0xFFC97C5D),  // Darker brown - used in Section 24G
  ];
  
  /// Returns a consistent color for a given project name
  static Color getColorForProject(String? projectName) {
    // Default color for null or empty project names
    if (projectName == null || projectName.isEmpty) {
      return Colors.grey.shade300;
    }
    
    // Return cached color if we've seen this project before
    if (_projectColors.containsKey(projectName)) {
      return _projectColors[projectName]!;
    }
    
    // Assign a new color based on the current map size
    final colorIndex = _projectColors.length % _colors.length;
    final color = _colors[colorIndex];
    
    // Cache the color for this project
    _projectColors[projectName] = color;
    
    return color;
  }
}

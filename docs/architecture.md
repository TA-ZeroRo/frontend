Developer: # Zeroro Frontend Architecture

## Overview

This document defines the architecture, code style, usage packages, and conventions for the Zeroro Frontend project. All development work should follow the principles outlined in this document.

## Project Structure

### Clean Architecture

The project follows Clean Architecture principles, and is organized into four layers as follows:

### Responsibilities by Layer

#### 1. Core Layer
- Global constants and settings
- Common utility functions
- Extension functions
- Common error handling

#### 2. Data Layer
- **data_source**: Access to external APIs, local DB, etc.
- **dto**: Entities for network/DB responses, suitable for serialization
- **repository_impl**: Implements the domain repository interface

Conventions:
- DTOs convert to Domain Models via `toModel()` methods
- Data Sources handle exceptions and are processed in Repositories
- Repositories do not include business logic

#### 3. Domain Layer
- **model**: Pure Dart entities used in business logic
- **repository**: Abstract interfaces for accessing data

Conventions:
- No Flutter framework dependencies
- Pure Dart code only
- Models are immutable
- Only interfaces are defined in repositories

#### 4. Presentation Layer
- **screens**: Top-level route containers
- **pages**: Tabs or sections within a screen
- **widgets**: Reusable UI components

Conventions:
- Separate UI logic from business logic
- State uses Riverpod Notifier pattern
- Widgets should be Stateless where possible

## Code Style

### Dart Style Guide

- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guide
- Adhere to lint rules in `analysis_options.yaml`
- Use the `flutter_lints` package

#### Networking
- `dio`: HTTP client
- `retrofit`: Type-safe REST client
- `pretty_dio_logger`: HTTP logging

#### Local Storage
- `shared_preferences`: Simple key-value storage
- `hive`: Local database
- `flutter_secure_storage`: Secure storage

#### JSON Serialization
- `json_serializable`: Automatic JSON serialization
- `freezed`: Immutable model generation

#### Utility
- `intl`: Internationalization/date formats
- `logger`: Logging
- `equatable`: Value equality

#### UI
- `cached_network_image`: Image caching
- `flutter_svg`: SVG support
- `shimmer`: Shimmer effect loading

## Additional Notes
**Image Caching:** Use network image caching
**Lazy Loading:** Defer loading of heavy resources
**Build Optimization:** Prevent unnecessary rebuilds
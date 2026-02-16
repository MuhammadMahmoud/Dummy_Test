"""
Code Injector - Dynamically inject code before/after statements for testing
Supports C code modification and restoration
"""

import re
import shutil
from pathlib import Path
from typing import Dict, List, Tuple


class CodeInjector:
    """Inject code into files for testing and restore them"""
    
    def __init__(self):
        self.backups: Dict[str, str] = {}  # Store original file contents
        self.injections: Dict[str, List[Tuple[str, str, str]]] = {}  # Track injections
    
    def backup_file(self, file_path: str) -> None:
        """Create backup of original file"""
        file_path = Path(file_path)
        if file_path.exists():
            self.backups[str(file_path)] = file_path.read_text()
        else:
            raise FileNotFoundError(f"File not found: {file_path}")
    
    def inject_before_statement(self, file_path: str, statement: str, injection: str) -> bool:
        """
        Inject code BEFORE a specific statement
        
        Args:
            file_path: Path to file to modify
            statement: Code statement to find (regex pattern)
            injection: Code to inject before statement
        
        Returns:
            True if injection successful, False if statement not found
        """
        file_path = Path(file_path)
        
        if str(file_path) not in self.backups:
            self.backup_file(str(file_path))
        
        content = file_path.read_text()
        original_content = content
        
        # Find the statement and inject before it
        pattern = f"({re.escape(statement)})"
        replacement = f"{injection}\n    {statement}"
        content = re.sub(pattern, replacement, content)
        
        if content == original_content:
            return False  # Statement not found
        
        file_path.write_text(content)
        
        # Track injection
        if str(file_path) not in self.injections:
            self.injections[str(file_path)] = []
        self.injections[str(file_path)].append(("before", statement, injection))
        
        return True
    
    def inject_after_statement(self, file_path: str, statement: str, injection: str) -> bool:
        """
        Inject code AFTER a specific statement
        
        Args:
            file_path: Path to file to modify
            statement: Code statement to find (regex pattern)
            injection: Code to inject after statement
        
        Returns:
            True if injection successful, False if statement not found
        """
        file_path = Path(file_path)
        
        if str(file_path) not in self.backups:
            self.backup_file(str(file_path))
        
        content = file_path.read_text()
        original_content = content
        
        # Find the statement and inject after it (with proper indentation)
        pattern = f"({re.escape(statement)})"
        replacement = f"{statement}\n    {injection}"
        content = re.sub(pattern, replacement, content)
        
        if content == original_content:
            return False  # Statement not found
        
        file_path.write_text(content)
        
        # Track injection
        if str(file_path) not in self.injections:
            self.injections[str(file_path)] = []
        self.injections[str(file_path)].append(("after", statement, injection))
        
        return True
    
    def inject_in_function(self, file_path: str, function_name: str, 
                          injection: str, position: str = "start") -> bool:
        """
        Inject code at start or end of a function
        
        Args:
            file_path: Path to file
            function_name: Name of function to inject into
            injection: Code to inject
            position: "start" or "end"
        
        Returns:
            True if successful
        """
        file_path = Path(file_path)
        
        if str(file_path) not in self.backups:
            self.backup_file(str(file_path))
        
        content = file_path.read_text()
        original_content = content
        
        # Find function definition
        func_pattern = rf"int\s+{function_name}\s*\([^)]*\)\s*\{{"
        
        if position == "start":
            # Inject after opening brace
            replacement = rf"\g<0>\n    {injection}"
            content = re.sub(func_pattern, replacement, content)
        elif position == "end":
            # Inject before closing brace
            # Find the function and inject before return
            func_pattern = rf"(int\s+{function_name}\s*\([^)]*\).*?)(return.*?;)"
            replacement = rf"\1{injection}\n    \2"
            content = re.sub(func_pattern, replacement, content, flags=re.DOTALL)
        
        if content == original_content:
            return False
        
        file_path.write_text(content)
        
        if str(file_path) not in self.injections:
            self.injections[str(file_path)] = []
        self.injections[str(file_path)].append(("in_function", function_name, injection))
        
        return True
    
    def restore_file(self, file_path: str) -> bool:
        """
        Restore file to original state
        
        Args:
            file_path: Path to file to restore
        
        Returns:
            True if restored, False if no backup exists
        """
        file_path = str(Path(file_path))
        
        if file_path not in self.backups:
            return False
        
        Path(file_path).write_text(self.backups[file_path])
        
        # Remove from tracking
        if file_path in self.injections:
            del self.injections[file_path]
        
        return True
    
    def restore_all_files(self) -> int:
        """
        Restore all modified files to original state
        
        Returns:
            Number of files restored
        """
        count = 0
        for file_path in list(self.backups.keys()):
            if self.restore_file(file_path):
                count += 1
        
        self.backups.clear()
        self.injections.clear()
        return count
    
    def get_injections_status(self) -> Dict:
        """Get current injection status"""
        return {
            "files_modified": len(self.injections),
            "backups_stored": len(self.backups),
            "injections": self.injections
        }

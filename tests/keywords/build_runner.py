"""
Code Builder and Runner - Compile and run C code, capture output
"""

import subprocess
from pathlib import Path
from typing import Tuple
import sys
import os


class BuildRunner:
    """Build and run C code, capture output"""
    
    def __init__(self, workspace_dir: str = None, build_dir: str = None):
        self.workspace_dir = Path(workspace_dir or r"d:\Workspace\Dummy")
        self.build_dir = Path(build_dir or self.workspace_dir / "Build")
        self.output_file = self.build_dir / "output.txt"
        self.last_exit_code = None
        self.last_stdout = None
        self.last_stderr = None
    
    def build_project(self, makefile: str = "makefile.mk") -> bool:
        """
        Build the project using makefile
        
        Args:
            makefile: Name of makefile
        
        Returns:
            True if build successful, False otherwise
        """
        makefile_path = self.build_dir / makefile
        
        if not makefile_path.exists():
            raise FileNotFoundError(f"Makefile not found: {makefile_path}")
        
        try:
            # Build using make
            result = subprocess.run(
                ["make", "-f", str(makefile_path)],
                cwd=str(self.build_dir),
                capture_output=True,
                text=True,
                timeout=30
            )
            
            self.last_stdout = result.stdout
            self.last_stderr = result.stderr
            self.last_exit_code = result.returncode
            
            if result.returncode != 0:
                print(f"Build failed: {result.stderr}")
                return False
            
            print("Build successful")
            return True
        
        except subprocess.TimeoutExpired:
            print("Build timed out")
            return False
        except Exception as e:
            print(f"Build error: {e}")
            return False
    
    def run_executable(self, exe_name: str = "mini_bank.exe", 
                      capture_output: bool = True) -> bool:
        """
        Run the compiled executable
        
        Args:
            exe_name: Name of executable
            capture_output: Whether to capture output to file
        
        Returns:
            True if execution successful, False otherwise
        """
        exe_path = self.build_dir / exe_name
        
        if not exe_path.exists():
            raise FileNotFoundError(f"Executable not found: {exe_path}")
        
        try:
            if capture_output:
                # Run and capture to file
                output = subprocess.run(
                    [str(exe_path)],
                    cwd=str(self.build_dir),
                    capture_output=True,
                    text=True,
                    timeout=10
                )
                
                # Save to output.txt
                with open(self.output_file, "w") as f:
                    f.write(output.stdout)
                    if output.stderr:
                        f.write("\n--- STDERR ---\n")
                        f.write(output.stderr)
            else:
                # Run without capturing (shows in console)
                output = subprocess.run(
                    [str(exe_path)],
                    cwd=str(self.build_dir),
                    timeout=10
                )
            
            self.last_exit_code = output.returncode
            self.last_stdout = output.stdout if capture_output else ""
            self.last_stderr = output.stderr if capture_output else ""
            
            return output.returncode == 0
        
        except subprocess.TimeoutExpired:
            print("Execution timed out")
            return False
        except Exception as e:
            print(f"Execution error: {e}")
            return False
    
    def build_and_run(self, makefile: str = "makefile.mk", 
                     exe_name: str = "mini_bank.exe") -> Tuple[bool, str]:
        """
        Build and run in one step
        
        Args:
            makefile: Name of makefile
            exe_name: Name of executable
        
        Returns:
            Tuple of (success: bool, output: str)
        """
        if not self.build_project(makefile):
            return False, "Build failed"
        
        if not self.run_executable(exe_name):
            return False, "Execution failed"
        
        output = self.get_output()
        return True, output
    
    def get_output(self) -> str:
        """Get captured output from last run"""
        if self.output_file.exists():
            return self.output_file.read_text()
        return self.last_stdout or ""
    
    def get_output_lines(self) -> list:
        """Get output as list of lines"""
        return self.get_output().strip().split("\n")
    
    def output_contains(self, text: str) -> bool:
        """Check if output contains text"""
        return text in self.get_output()
    
    def output_contains_all(self, *texts: str) -> bool:
        """Check if output contains all texts"""
        output = self.get_output()
        return all(text in output for text in texts)
    
    def output_contains_any(self, *texts: str) -> bool:
        """Check if output contains any of the texts"""
        output = self.get_output()
        return any(text in output for text in texts)
    
    def get_last_exit_code(self) -> int:
        """Get exit code from last execution"""
        return self.last_exit_code or -1
    
    def clear_output(self) -> None:
        """Clear output file"""
        if self.output_file.exists():
            self.output_file.write_text("")
    
    def get_output_file_path(self) -> str:
        """Get path to output file"""
        return str(self.output_file)

"""
C Code Test Library - Robot Framework library for testing C code
Combines code injection and build/run functionality
"""

from .code_injector import CodeInjector
from .build_runner import BuildRunner
from pathlib import Path


class CCodeTestLibrary:
    """Test library for C code with injection and build capability"""
    
    ROBOT_LIBRARY_SCOPE = "SUITE"
    
    def __init__(self, workspace_dir=None, build_dir=None):
        self.injector = CodeInjector()
        self.runner = BuildRunner(workspace_dir, build_dir)
        self.workspace_dir = Path(workspace_dir or r"d:\Workspace\Dummy")
        self.build_dir = Path(build_dir or self.workspace_dir / "Build")
    
    # ===================== INJECTION KEYWORDS =====================
    
    def backup_file(self, file_path):
        """
        Backup a file before modifications
        
        Example:
            | Backup File | d:\\Workspace\\Dummy\\main.c |
        """
        self.injector.backup_file(file_path)
    
    def inject_code_before(self, file_path, statement, injection_code):
        """
        Inject code BEFORE a specific statement
        
        Args:
            file_path: File to modify
            statement: Statement to find
            injection_code: Code to inject before statement
        
        Example:
            | Inject Code Before | d:\\Workspace\\Dummy\\main.c | printf("test"); | printf("Account 1 Balance: %.2f\\\\n", get_balance(&a1)); |
        """
        success = self.injector.inject_before_statement(file_path, statement, injection_code)
        if not success:
            raise AssertionError(f"Statement not found: {statement}")
    
    def inject_code_after(self, file_path, statement, injection_code):
        """
        Inject code AFTER a specific statement
        
        Args:
            file_path: File to modify
            statement: Statement to find
            injection_code: Code to inject after statement
        
        Example:
            | Inject Code After | d:\\Workspace\\Dummy\\main.c | printf("starting"); | printf("\\\\nTest Output:"); |
        """
        success = self.injector.inject_after_statement(file_path, statement, injection_code)
        if not success:
            raise AssertionError(f"Statement not found: {statement}")
    
    def restore_file(self, file_path):
        """
        Restore a file to original state
        
        Example:
            | Restore File | d:\\Workspace\\Dummy\\main.c |
        """
        success = self.injector.restore_file(file_path)
        if not success:
            raise AssertionError(f"No backup found for file: {file_path}")
    
    def restore_all_files(self):
        """
        Restore all modified files to original state
        
        Example:
            | Restore All Files |
        """
        count = self.injector.restore_all_files()
        return count
    
    def get_injection_status(self):
        """
        Get current injection status
        
        Returns:
            Status dictionary
        
        Example:
            | ${status}= | Get Injection Status |
        """
        return self.injector.get_injections_status()
    
    # ===================== BUILD KEYWORDS =====================
    
    def build_project(self, makefile="makefile.mk"):
        """
        Build the project
        
        Args:
            makefile: Name of makefile (default: makefile.mk)
        
        Example:
            | Build Project |
        """
        success = self.runner.build_project(makefile)
        if not success:
            raise AssertionError("Build failed")
    
    def run_executable(self, exe_name="mini_bank.exe"):
        """
        Run the compiled executable
        
        Args:
            exe_name: Name of executable
        
        Example:
            | Run Executable |
        """
        success = self.runner.run_executable(exe_name)
        if not success:
            raise AssertionError("Execution failed")
    
    def build_and_run(self, makefile="makefile.mk", exe_name="mini_bank.exe"):
        """
        Build and run in one step
        
        Args:
            makefile: Name of makefile
            exe_name: Name of executable
        
        Example:
            | Build And Run |
        """
        success, output = self.runner.build_and_run(makefile, exe_name)
        if not success:
            raise AssertionError(f"Build/Run failed: {output}")
    
    # ===================== OUTPUT VERIFICATION KEYWORDS =====================
    
    def get_output(self):
        """
        Get output from last execution
        
        Returns:
            Output text
        
        Example:
            | ${output}= | Get Output |
        """
        return self.runner.get_output()
    
    def output_should_contain(self, text):
        """
        Verify output contains text
        
        Args:
            text: Text to find in output
        
        Example:
            | Output Should Contain | Account 1 Balance: 1200.00 |
        """
        if not self.runner.output_contains(text):
            output = self.runner.get_output()
            raise AssertionError(
                f"Output does not contain '{text}'\n"
                f"Actual output:\n{output}"
            )
    
    def output_should_contain_all(self, *texts):
        """
        Verify output contains all texts
        
        Args:
            *texts: Texts to find in output
        
        Example:
            | Output Should Contain All | Account 1 Balance: 1200.00 | Account 2 Balance: 700.00 |
        """
        if not self.runner.output_contains_all(*texts):
            output = self.runner.get_output()
            raise AssertionError(
                f"Output does not contain all: {texts}\n"
                f"Actual output:\n{output}"
            )
    
    def output_should_contain_any(self, *texts):
        """
        Verify output contains any of the texts
        
        Args:
            *texts: At least one of these must be in output
        
        Example:
            | Output Should Contain Any | success | Success | SUCCESS |
        """
        if not self.runner.output_contains_any(*texts):
            output = self.runner.get_output()
            raise AssertionError(
                f"Output does not contain any of: {texts}\n"
                f"Actual output:\n{output}"
            )
    
    def output_should_not_contain(self, text):
        """
        Verify output does NOT contain text
        
        Args:
            text: Text that should NOT be in output
        
        Example:
            | Output Should Not Contain | error |
        """
        if self.runner.output_contains(text):
            output = self.runner.get_output()
            raise AssertionError(
                f"Output contains forbidden text '{text}'\n"
                f"Actual output:\n{output}"
            )
    
    def output_line_should_contain(self, line_number, text):
        """
        Verify specific line contains text
        
        Args:
            line_number: Line number (1-indexed)
            text: Text to find
        
        Example:
            | Output Line Should Contain | 1 | Account 1 Balance |
        """
        lines = self.runner.get_output_lines()
        line_number = int(line_number)
        
        if line_number < 1 or line_number > len(lines):
            raise AssertionError(f"Line {line_number} does not exist (total lines: {len(lines)})")
        
        line = lines[line_number - 1]
        if text not in line:
            raise AssertionError(
                f"Line {line_number} does not contain '{text}'\n"
                f"Actual line: {line}"
            )
    
    # ===================== WORKFLOW KEYWORDS =====================
    
    def test_with_injection(self, description, c_file, statement_to_find, 
                           injection_code, expected_output):
        """
        Complete test workflow: inject, build, run, verify, restore
        
        Args:
            description: Test description
            c_file: Path to C file
            statement_to_find: Statement to find and inject before
            injection_code: Code to inject
            expected_output: Expected output to verify
        
        Example:
            | Test With Injection | Test Account Balance | d:\\Workspace\\Dummy\\main.c | deposit(&a1, 200.0); | printf("\\\\nINJECTED TEST"); | INJECTED TEST |
        """
        print(f"\n=== {description} ===")
        
        # Backup and inject
        self.backup_file(c_file)
        self.inject_code_after(c_file, statement_to_find, injection_code)
        print(f"✓ Code injected")
        
        # Build and run
        self.build_and_run()
        print(f"✓ Build and run complete")
        
        # Verify output
        self.output_should_contain(expected_output)
        print(f"✓ Output verified: '{expected_output}' found")
        
        # Restore
        self.restore_file(c_file)
        print(f"✓ File restored to original")
    
    def get_output_file_path(self):
        """
        Get path to output file
        
        Returns:
            Path to output.txt
        
        Example:
            | ${output_path}= | Get Output File Path |
        """
        return self.runner.get_output_file_path()    
    def cleanup_after_test(self):
        """
        Cleanup after each test: restore all modified files
        
        Example:
            | Cleanup After Test |
        """
        self.restore_all_files()
    
    def cleanup_after_suite(self):
        """
        Cleanup after entire test suite: restore all modified files
        
        Example:
            | Cleanup After Suite |
        """
        self.restore_all_files()
    
    def suite_setup(self):
        """
        Setup for test suite: ensure clean state
        
        Example:
            | Suite Setup |
        """
        self.restore_all_files()
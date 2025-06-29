function bench --description "Benchmark Fish shell performance"
    set -l start_time (date +%s.%N)
    
    echo "Fish Shell Benchmark"
    echo "==================="
    echo ""
    
    # Test shell startup time
    echo "1. Shell Startup Time:"
    set -l shell_start (time fish -c "true" 2>&1 | grep "real" | string replace -r ".*real\s+" "")
    echo "   $shell_start"
    echo ""
    
    # Test command execution time
    echo "2. Command Execution:"
    echo "   - Simple command:"
    set -l simple_cmd (time echo "test" >/dev/null 2>&1 | grep "real" | string replace -r ".*real\s+" "")
    echo "     $simple_cmd"
    echo "   - Complex command:"
    set -l complex_cmd (time ls -la /usr/bin | head -n 10 >/dev/null 2>&1 | grep "real" | string replace -r ".*real\s+" "")
    echo "     $complex_cmd"
    echo ""
    
    # Test completion time
    echo "3. Completion Performance:"
    echo "   - Testing completion:"
    set -l completion_time (time complete -C "git " >/dev/null 2>&1 | grep "real" | string replace -r ".*real\s+" "")
    echo "     $completion_time"
    echo ""
    
    # Test history performance
    echo "4. History Performance:"
    echo "   - History size:"
    set -l history_size (count (history))
    echo "     $history_size entries"
    echo "   - History search:"
    set -l history_search (time history | grep "git" | head -n 1 >/dev/null 2>&1 | grep "real" | string replace -r ".*real\s+" "")
    echo "     $history_search"
    echo ""
    
    # Test path resolution
    echo "5. Path Resolution:"
    echo "   - PATH size:"
    set -l path_size (count $PATH)
    echo "     $path_size directories"
    echo "   - Command lookup:"
    set -l cmd_lookup (time which git >/dev/null 2>&1 | grep "real" | string replace -r ".*real\s+" "")
    echo "     $cmd_lookup"
    echo ""
    
    # Test variable access
    echo "6. Variable Access:"
    echo "   - Simple variable:"
    set -l var_time (time echo $PATH >/dev/null 2>&1 | grep "real" | string replace -r ".*real\s+" "")
    echo "     $var_time"
    echo "   - Large variable:"
    set -l large_var (env | string collect)
    set -l large_var_time (time echo $large_var >/dev/null 2>&1 | grep "real" | string replace -r ".*real\s+" "")
    echo "     $large_var_time"
    echo ""
    
    # Calculate total time
    set -l end_time (date +%s.%N)
    set -l total_time (math "$end_time - $start_time")
    echo "Total benchmark time: $total_time seconds"
    echo ""
    echo "Note: Lower times are better. Times may vary between runs."
end 
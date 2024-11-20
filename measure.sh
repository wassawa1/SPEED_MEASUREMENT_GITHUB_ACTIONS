#!/usr/bin/bash

# スクリプトファイルの定義
PERL_SCRIPT="./string_replace.pl"
PYTHON_SCRIPT="./string_replace.py"

# Conda環境のリスト
CONDA_ENVS=("testenv310" "testenv311" "testenv312" "testenv313")

# 実行回数
ITERATIONS=5

# レポート用変数
REPORT="Execution Time Report:\n"

# Perlスクリプトの実行
if [[ -f "$PERL_SCRIPT" ]]; then
  echo "Running Perl script..."
  TOTAL_TIME=0
  for ((i=1; i<=ITERATIONS; i++)); do
    TIME=$(/usr/bin/time -f "%e" perl "$PERL_SCRIPT" 2>&1 > /dev/null)
    TOTAL_TIME=$(echo "$TOTAL_TIME + $TIME" | bc)
  done
  AVG_TIME=$(echo "scale=6; $TOTAL_TIME / $ITERATIONS" | bc)
  REPORT+="Perl: $AVG_TIME seconds (average of $ITERATIONS runs)\n"
else
  echo "Perl script not found: $PERL_SCRIPT"
  REPORT+="Perl: script not found\n"
fi

# 各Conda環境でPythonスクリプトを実行
for ENV in "${CONDA_ENVS[@]}"; do
  if [[ -f "$PYTHON_SCRIPT" ]]; then
    echo "Activating Conda environment: $ENV"
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate "$ENV"

    TOTAL_TIME=0
    for ((i=1; i<=ITERATIONS; i++)); do
      TIME=$(/usr/bin/time -f "%e" python "$PYTHON_SCRIPT" 2>&1 > /dev/null)
      TOTAL_TIME=$(echo "$TOTAL_TIME + $TIME" | bc)
    done
    AVG_TIME=$(echo "scale=6; $TOTAL_TIME / $ITERATIONS" | bc)
    REPORT+="$ENV: $AVG_TIME seconds (average of $ITERATIONS runs)\n"

    conda deactivate
  else
    echo "Python script not found: $PYTHON_SCRIPT"
    REPORT+="$ENV: Python script not found\n"
  fi
done

# レポートの出力
echo -e "$REPORT"

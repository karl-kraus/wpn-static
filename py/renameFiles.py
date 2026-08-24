from pathlib import Path


def rename_files(path: str = 'e2e/specs/edition_typo_view.spec.ts-snapshots'):
    # Define the directory containing the files to be renamed
    directory = Path(path)

    # Loop through all files in the directory
    for file in directory.glob('*.png'):
        # Define the new file name
        new_file_name = file.stem.replace('idPb', 'wit-DfeH-') + file.suffix
        new_file_path = file.parent / new_file_name
        
        # Rename the file
        file.rename(new_file_path)
        print(f'Renamed: {file} to {new_file_path}')


if __name__ == '__main__':
    rename_files('e2e/specs/edition_typo_view_prod.spec.ts-snapshots')
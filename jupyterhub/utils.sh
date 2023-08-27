#!/usr/bin/env bash

set -e

setup_directory () {
    local directory="${1}"
    local permissions="${2:-}"
    echo "Creating directory '${directory}' with permissions '${permissions}'"
    if [ ! -d "${directory}" ]; then
        mkdir -p "${directory}"
        if [[ ! -z "${permissions}" ]]; then
            chmod "${permissions}" "${directory}"
        fi
    fi
}

make_user () {
    local USER="${1}"
    echo "Creating user '${USER}'"
    useradd "${USER}"
    yes "${USER}" | passwd "${USER}"
    mkdir "/home/${USER}"
    chown "${USER}:${USER}" "/home/${USER}"
    
    local runas="sudo -u ${USER}"
    #${runas} PATH=${PATH}:/opt/conda/bin/
    #tail -n 5 /home/${USER}/.bashrc | echo
}


install_nbgrader () {
    local nbgrader_root="${1}"
    local exchange_root="${2}"

    echo "Installing nbgrader in '${nbgrader_root}'..."

    # Clone nbgrader.
    if [ ! -d "${nbgrader_root}" ]; then
        mkdir -p "${nbgrader_root}"
        cd "${nbgrader_root}"
        git clone https://github.com/jupyter/nbgrader .
    fi

    # Update git repository.
    cd "${nbgrader_root}"
    git pull

    # Install requirements and nbgrader.
    pip3 install -e ".[dev,docs,tests]"

    # Install global extensions, and disable them globally. We will re-enable
    # specific ones for different user accounts in each demo.
    jupyter labextension develop --overwrite .
    jupyter labextension disable --level=sys_prefix nbgrader:assignment-list
    jupyter labextension disable --level=sys_prefix nbgrader:formgrader
    jupyter labextension disable --level=sys_prefix nbgrader:course-list
    jupyter labextension disable --level=sys_prefix nbgrader:create-assignment
    jupyter server extension disable --sys-prefix --py nbgrader

    # Everybody gets the validate extension, however.
    jupyter labextension enable --level=sys_prefix nbgrader:validate-assignment
    jupyter server extension enable --sys-prefix nbgrader.server_extensions.validate_assignment

    # Reset exchange.
    rm -rf "${exchange_root}"
    setup_directory "${exchange_root}" ugo+rwx

    # Remove global nbgrader configuration, if it exists.
    rm -f /etc/jupyter/nbgrader_config.py
}

setup_nbgrader () {
    USER="${1}"
    HOME="/home/${USER}"

    local config="${2}"
    local runas="sudo -u ${USER}"

    echo "Setting up nbgrader for user '${USER}'"

    ${runas} mkdir -p "${HOME}/.jupyter"
    ${runas} cp "${config}" "${HOME}/.jupyter/nbgrader_config.py"
    ${runas} chown "${USER}:${USER}" "${HOME}/.jupyter/nbgrader_config.py"

    cp "/root/formgrader_workspace.json" "${HOME}/formgrader_workspace.json"
    chown "${USER}:${USER}" "${HOME}/formgrader_workspace.json"
    ${runas} jupyter lab workspaces import "${HOME}/formgrader_workspace.json"
}

setup_jupyterhub () {
    local jupyterhub_root="${1}"

    echo "Setting up JupyterHub to run in '${jupyterhub_root}'"

    # Ensure JupyterHub directory exists.
    setup_directory ${jupyterhub_root}

    # Delete old files, if they are there.
    rm -f "${jupyterhub_root}/jupyterhub.sqlite"
    rm -f "${jupyterhub_root}/jupyterhub_cookie_secret"

    # Copy config file.
    # cp jupyterhub_config.py "${jupyterhub_root}/jupyterhub_config.py"
}

enable_create_assignment () {
    USER="${1}"
    HOME="/home/${USER}"
    local runas="sudo -u ${USER}"

    ${runas} /opt/conda/bin/jupyter labextension disable --level=user nbgrader:create-assignment
    ${runas} /opt/conda/bin/jupyter labextension enable --level=user nbgrader:create-assignment
}

enable_formgrader () {
    USER="${1}"
    HOME="/home/${USER}"
    local runas="sudo -u ${USER}"

    ${runas} /opt/conda/bin/jupyter labextension disable --level=user nbgrader:formgrader
    ${runas} /opt/conda/bin/jupyter labextension enable --level=user nbgrader:formgrader
    ${runas} /opt/conda/bin/jupyter server extension enable --user nbgrader.server_extensions.formgrader
}

enable_assignment_list () {
    USER="${1}"
    HOME="/home/${USER}"
    local runas="sudo -u ${USER}"

    ${runas} /opt/conda/bin/jupyter labextension disable --level=user nbgrader:assignment-list
    ${runas} /opt/conda/bin/jupyter labextension enable --level=user nbgrader:assignment-list
    ${runas} /opt/conda/bin/jupyter server extension enable --user nbgrader.server_extensions.assignment_list
}

enable_course_list () {
    USER="${1}"
    HOME="/home/${USER}"
    local runas="sudo -u ${USER}"
    echo `whoami`

    ${runas} /opt/conda/bin/jupyter labextension disable --level=user nbgrader:course-list
    ${runas} /opt/conda/bin/jupyter labextension enable --level=user nbgrader:course-list
    ${runas} /opt/conda/bin/jupyter server extension enable --user nbgrader.server_extensions.course_list
}

create_course () {
    USER="${1}"
    HOME="/home/${USER}"
    local course="${2}"
    local runas="sudo -u ${USER}"
    local currdir="$(pwd)"

    echo $PATH
    cd "${HOME}"
    ${runas} /opt/conda/bin/nbgrader quickstart "${course}"
    cd "${course}"
    ${runas} /opt/conda/bin/nbgrader generate_assignment ps1
    ${runas} /opt/conda/bin/nbgrader release_assignment ps1
    cd "${currdir}"
}

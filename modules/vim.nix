(
  with import <nixpkgs> {};

  vim_configurable.customize {
    # Specifies the vim binary name.
    # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
    # This allows to have multiple vim packages installed (e.g. with a different set of plugins)
    name = "vim";
    vimrcConfig = {
      customRC = ''
        syntax on
        filetype plugin indent on

        set number
        set wrap
        set noswapfile
        set nobackup
        set nowritebackup
        set lazyredraw

        set winheight=5
        set winminheight=5

        set tabstop=4
        set softtabstop=4
        set shiftwidth=4
        set expandtab

        set showmatch
        set matchtime=1

        set wildmenu

        set path=**
        nnoremap <leader>f :find *

        nnoremap <leader>s :GFiles<CR>
        nnoremap <leader>l :ls<cr>:b<space>

        set incsearch
        set hlsearch
        set ignorecase
        set smartcase

        set hidden

        set laststatus=2

        set scrolloff=5

        set backspace=indent,eol,start

        set ruler

        " Save as sudo
        cmap w!! w !sudo tee > /dev/null %

        " Required, explicitly enable Elixir LS
        let g:ale_linters = {}
        let g:ale_linters.elixir = ['elixir-ls']

        " Required, tell ALE where to find Elixir LS
        let g:ale_elixir_elixir_ls_release = expand("${pkgs.elixir_ls}/lib")

        " Optional, you can disable Dialyzer with this setting
        let g:ale_elixir_elixir_ls_config = {'elixirLS': {'dialyzerEnabled': v:false}}

        " Optional, configure as-you-type completions
        set completeopt=menu,menuone,preview,noselect,noinsert
        let g:ale_completion_enabled = 1
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        # loaded on launch
        start = [ nerdtree vim-elixir ale fugitive vim-gitgutter fzf-vim vim-vinegar ];
        # manually loadable by calling `:packadd $plugin-name`
        #opt = [ phpCompletion elm-vim ];
        # To automatically load a plugin when opening a filetype, add vimrc lines like:
        # autocmd FileType php :packadd phpCompletion
      };
    };
  }
)


# -*- coding: utf-8 -*-
require 'hikidoc'

class HikiDoc
  class TexOutput
    def initialize
      @f = nil
    end

    def reset
      @f = StringIO.new
      @f.puts <<-'EOS'
\documentclass[a4paper]{jarticle}

\usepackage[dvips]{graphics}
\usepackage[dvips]{graphicx}
\usepackage{multirow}
\usepackage{enumerate}
\usepackage{amsmath}
\usepackage{hyperref}
\usepackage{ascmac}
%\usepackage{times,latexsym,mathptm}
\usepackage{alltt}
\usepackage{framed,color}
\definecolor{shadecolor}{gray}{0.90}
\usepackage{ascmac}
\usepackage{listings}
\lstset{%
 language={C},
 basicstyle={\small},%
 identifierstyle={\small},%
 commentstyle={\small\itshape},%
 keywordstyle={\small\bfseries},%
 ndkeywordstyle={\small},%
 stringstyle={\small\ttfamily},
 frame={tb},
 breaklines=true,
 columns=[l]{fullflexible},%
 numbers=left,%
 xrightmargin=0zw,%
 xleftmargin=3zw,%
 numberstyle={\scriptsize},%
 stepnumber=1,
 numbersep=1zw,%
 lineskip=-0.5ex%
}

%\numberwithin{equation}{section}
%\topmargin = 0mm
\oddsidemargin = 0mm
\headheight = 0mm
\marginparwidth = 0mm
\textwidth = 160mm

% newcommand \mathbf for mathbold (usage $\mathbf{x}$)
%\DeclareMathAlphabet{\mathbf}{OT1}{ptm}{b}{it}
% slanted Greek letter in math-mode
%\DeclareSymbolFont{letters}{OML}{ztmcm}{m}{it}
% use Computer-Modern tt-font for typewriterfont
%\renewcommand{\ttdefault}{cmtt}

\newdimen\sheetwidth \newdimen\sheetheight
\def\Afoursheet{\sheetwidth=210mm \sheetheight=297mm}
\def\AfourRsheet{\sheetwidth=297mm \sheetheight=210mm}
\def\Afivesheet{\sheetwidth=148mm \sheetheight=210mm}
\def\Bfoursheet{\sheetwidth=257mm \sheetheight=363mm}
\def\Bfivesheet{\sheetwidth=182mm \sheetheight=257mm}
\def\Lettersheet{\sheetwidth=8.5in \sheetheight=11in}
\def\sheetcenter{ \oddsidemargin=\sheetwidth
 \advance\oddsidemargin-\textwidth \oddsidemargin=0.5\oddsidemargin
 \advance\oddsidemargin-1in \evensidemargin=\oddsidemargin
 \topmargin=\sheetheight \advance\topmargin-\textheight
 \topmargin=0.5\topmargin \advance\topmargin-\headheight
 \advance\topmargin-\headsep \advance\topmargin-1in }
\Afoursheet\textwidth=48zw\textheight=250mm\sheetcenter

% indent of paragraph
\setlength{\parindent}{1zw}

\usepackage{fancyhdr}
\pagestyle{fancy}

\begin{document}

      EOS
    end

    def finish
      @f.puts '\end{document}'
      @f.string
    end

    def container(_for=nil)
      case _for
      when :paragraph
        []
      else
        ""
      end
    end

    #
    # Procedures
    #

    def headline(level, title)
      case level
      when 1
        @f.puts "\\part{#{title}}"
      when 2
        @f.puts "\\section{#{title}}"
      when 3
        @f.puts "\\subsection{#{title}}"
      when 4
        @f.puts "\\subsubsection{#{title}}"
      else
        @f.puts "\\paragraph{#{title}}"
      end
    end

    def hrule
      @f.puts '\hrule'
    end

    def list_begin(type)
      case type
      when ULIST
        @f.puts '\begin{itemize}'
      when OLIST
        @f.puts '\begin{enumerate}'
      end
    end

    def list_end(type)
      case type
      when ULIST
        @f.puts '\end{itemize}'
      when OLIST
        @f.puts '\end{enumerate}'
      end
    end

    def listitem_open
      @f.print '\item '
    end

    def listitem_close
    end

    def listitem(item)
      @f.puts item
    end

    def dlist_open
      @f.puts '\begin{description}'
    end

    def dlist_close
      @f.puts '\end{description}'
    end

    def dlist_item(dt, dd)
      @f.puts "\\item #{dt}" unless dt.empty?
      @f.puts "\\item #{dd}" unless dd.empty?
    end

    def table_open
      @f.puts '\begin{tabular} \hline'
    end

    def table_close
      @f.puts '\end{tabular}'
    end

    def table_record_open
    end

    def table_record_close
    end

    def table_head(item, rs, cs)
      # TODO
    end

    def table_data(item, rs, cs)
      # TODO
    end

    def tdattr(rs, cs)
      buf = ""
      buf << %Q( rowspan="#{rs}") if rs
      buf << %Q( colspan="#{cs}") if cs
      buf
    end
    private :tdattr

    def blockquote_open
      @f.puts '\begin{shadebox}'
      @f.puts '\begin{quote}'
    end

    def blockquote_close
      @f.puts '\end{quote}'
      @f.puts '\end{shadebox}'
    end

    def block_preformatted(str, syntax)
      if syntax
        begin
          source_code(str, syntax)
          return
        rescue NameError, RuntimeError
        end
      end
      preformatted(str)
    end

    def source_code(str, syntax)
      @f.puts "\\begin{lstlisting}[language=#{syntax}]"
      @f.print str
      @f.print '\end{lstlisting}'
    end

    def preformatted(str)
      @f.print '\begin{screen}'
      @f.print '\begin{verbatim}'
      @f.print str
      @f.puts '\end{verbatim}'
      @f.print '\end{screen}'
    end

    def paragraph(lines)
      @f.puts "#{lines.join("\n")}\\\\"
    end

    def block_plugin(str)
      str
    end

    #
    # Functions
    #

    def hyperlink(uri, title)
      %Q(#{title} - #{uri})
    end

    def wiki_name(name)
      hyperlink(name, text(name))
    end

    def image_hyperlink(uri, alt = nil)
      alt ||= uri.split(/\//).last
      str = "\\includegraphics{#{url}}"
      str += "\\caption{#{alt}}" unless alt.empty?
    end

    def strong(item)
      "\\bf{#{item}}"
    end

    def em(item)
      "\\em{#{item}}"
    end

    def del(item)
      # TODO
    end

    def text(str)
      escape(str)
    end

    def inline_plugin(src)
      escape(src)
    end

    #
    # Utilities
    #

    ALLTT_META_CHAR = {
      '%' => '\\%',
      '{' => '\\{',
      '}' => '\\}',
      '\\' => '\\textbackslash{}',
    }

    META_CHAR = ALLTT_META_CHAR.merge({
      '_' => '\\textunderscore{}',
      '~' => '\\textasciitilde{}',
      '#' => '\\#',
      '&' => '\\&',
      '$' => '\\$', #'
      '<' => '$<$',
      '>' => '$>$',
      'LaTeX' => '\\LaTeX{}',
      'TeX' => '\\TeX{}',
    })

    ALLTT_META_CHAR_RE = /[#{ALLTT_META_CHAR.keys.collect{|x| Regexp.escape(x)}}]/
    META_CHAR_RE = /(?:#{META_CHAR.keys.collect{|x| Regexp.escape(x)}.join('|')})/

    def alltt_meta_char_escape(str)
      str.gsub(ALLTT_META_CHAR_RE) do |x|
        ALLTT_META_CHAR[x]
      end
    end

    def meta_char_escape(str)
      str.gsub(META_CHAR_RE) do |x|
        META_CHAR[x]
      end
    end

    def escape(str)
      meta_char_escape(str)
    end
  end
end

class HikiDoc2Tex < HikiDoc
  def HikiDoc2Tex.to_tex(src, options = {})
    new(TexOutput.new, options).compile(src)
  end

  ULIST_RE = /\A#{Regexp.union(ULIST)}+/
  OLIST_RE = /\A#{Regexp.union(OLIST)}+/

  def compile_blocks(src)
    f = LineInput.new(StringIO.new(src))
    while line = f.peek
      case line
      when COMMENT_RE
        f.gets
      when HEADER_RE
        compile_header f.gets
      when HRULE_RE
        f.gets
        compile_hrule
      when ULIST_RE
        compile_list f, ULIST
      when OLIST_RE
        compile_list f, OLIST
      when DLIST_RE
        compile_dlist f
      when TABLE_RE
        compile_table f
      when BLOCKQUOTE_RE
        compile_blockquote f
      when INDENTED_PRE_RE
        compile_indented_pre f
      when BLOCK_PRE_OPEN_RE
        compile_block_pre f
      else
        if /^$/ =~ line
          f.gets
          next
        end
        compile_paragraph f
      end
    end
  end

  def compile_list(f, list_type = nil)
    typestack = []
    level = 0
    @output.list_begin(list_type)
    f.while_match(LIST_RE) do |line|
      new_level = line.slice(LIST_RE).size
      item = strip(line.sub(LIST_RE, ""))
      if new_level > level
        (new_level - level).times do
          typestack.push list_type
          @output.listitem_open
        end
        @output.listitem compile_inline(item)
      elsif new_level < level
        (level - new_level).times do
          @output.listitem_close
        end
        @output.listitem_close
        @output.listitem_open
        @output.listitem compile_inline(item)
      elsif list_type == typestack.last
        @output.listitem_close
        @output.listitem_open
        @output.listitem compile_inline(item)
      else
        @output.listitem_close
        @output.listitem_open
        @output.listitem compile_inline(item)
        typestack.push list_type
      end
      level = new_level
      skip_comments f
    end
    level.times do
      @output.listitem_close
    end
    @output.list_end(list_type)
  end
end

if __FILE__ == $0
  puts HikiDoc2Tex.to_tex(ARGF.read(nil))
end

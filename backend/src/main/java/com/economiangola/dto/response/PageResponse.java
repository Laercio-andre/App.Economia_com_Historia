// src/main/java/com/economiangola/dto/response/PageResponse.java
package com.economiangola.dto.response;

import lombok.*;
import org.springframework.data.domain.Page;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageResponse<T> {

    private List<T> conteudo;
    private int pagina;
    private int tamanho;
    private long totalElementos;
    private int totalPaginas;
    private boolean primeira;
    private boolean ultima;

    public static <T> PageResponse<T> de(Page<T> page) {
        return PageResponse.<T>builder()
                .conteudo(page.getContent())
                .pagina(page.getNumber())
                .tamanho(page.getSize())
                .totalElementos(page.getTotalElements())
                .totalPaginas(page.getTotalPages())
                .primeira(page.isFirst())
                .ultima(page.isLast())
                .build();
    }

    public static <T, U> PageResponse<U> de(Page<T> page, List<U> conteudo) {
        return PageResponse.<U>builder()
                .conteudo(conteudo)
                .pagina(page.getNumber())
                .tamanho(page.getSize())
                .totalElementos(page.getTotalElements())
                .totalPaginas(page.getTotalPages())
                .primeira(page.isFirst())
                .ultima(page.isLast())
                .build();
    }
}

// src/main/java/com/economiangola/domain/entity/ConteudoMidia.java
package com.economiangola.domain.entity;

import com.economiangola.domain.enums.TipoMidia;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "conteudo_midias")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConteudoMidia extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conteudo_id", nullable = false)
    private Conteudo conteudo;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_midia", nullable = false, length = 20)
    private TipoMidia tipoMidia;

    @Column(name = "url", nullable = false, length = 1000)
    private String url;

    @Column(name = "titulo", length = 255)
    private String titulo;

    @Column(name = "descricao", length = 500)
    private String descricao;

    @Column(name = "ordem", nullable = false)
    @Builder.Default
    private Integer ordem = 0;
}

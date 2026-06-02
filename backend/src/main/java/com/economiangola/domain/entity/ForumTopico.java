// src/main/java/com/economiangola/domain/entity/ForumTopico.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "forum_topicos")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ForumTopico extends SoftDeletableEntity {

    @Column(name = "titulo", nullable = false, length = 255)
    private String titulo;

    @Column(name = "slug", nullable = false, unique = true, length = 300)
    private String slug;

    @Column(name = "corpo", nullable = false, columnDefinition = "TEXT")
    private String corpo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "autor_id", nullable = false)
    private Usuario autor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_id", nullable = false)
    private Categoria categoria;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conteudo_id")
    private Conteudo conteudo;

    @Column(name = "fixado", nullable = false)
    @Builder.Default
    private Boolean fixado = false;

    @Column(name = "fechado", nullable = false)
    @Builder.Default
    private Boolean fechado = false;

    @Column(name = "visualizacoes", nullable = false)
    @Builder.Default
    private Long visualizacoes = 0L;

    @OneToMany(mappedBy = "topico", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<ForumResposta> respostas = new ArrayList<>();
}
